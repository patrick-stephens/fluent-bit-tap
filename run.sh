#!/bin/bash
set -eux
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

IMAGE=${IMAGE:-fluent-bit-dynamic-query}
# git clone -b sp_dynamic_queries https://github.com/fluent/fluent-bit.git
# docker build ...

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
