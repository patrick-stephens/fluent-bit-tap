#!/bin/bash
set -eux
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

IMAGE=${IMAGE:-fluent-bit-dynamic-query}

# If we have no source then assume not built it yet - remove source to force a rebuild too
if [[ ! -d fluent-bit-source ]]; then
    docker rmi -f "$IMAGE"
    git clone -b stream_processing_dynamic_query https://github.com/fluent/fluent-bit.git fluent-bit-source
    DOCKER_BUILDKIT=1 docker build --target=production -t "$IMAGE" -f "$SCRIPT_DIR"/fluent-bit-source/dockerfiles/Dockerfile "$SCRIPT_DIR"/fluent-bit-source
fi

docker rm -f fluent-bit-tap
docker run --name fluent-bit-tap --rm -it -p 2020:2020 -v "$SCRIPT_DIR"/fluent-bit:/fluent-bit/etc:ro -d "$IMAGE"

# Let us start up and fill the pipe up
sleep 5

# Add the query
curl -H "Content-Type: application/json" http://localhost:2020/api/v1/stream_processor/task --data "@$SCRIPT_DIR/query.json"
curl http://localhost:2020/api/v1/stream_processor/list| jq .

# Run the query every 5s
until ! curl http://localhost:2020/api/v1/stream_processor/flush/live_query| jq . ; do
    sleep 5
done

# docker stop fluent-bit-tap
