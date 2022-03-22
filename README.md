# Fluent Bit dynamic querying

Example of how to use dynamic SQL queries to "tap" into Fluent Bit pipeline to see what is going on live.

It builds from the branch that includes the extra querying and provides 5 records output at a time.

Currently this only does it at the end of the pipeline rather than in-between each state.
```
[
  {
    "__flb_record_time": 1647959894.404941,
    "record": {
      "message": "dummy",
      "filter_1": "true",
      "filter_2": "true"
    }
  },
  {
    "__flb_record_time": 1647959895.404888,
    "record": {
      "message": "dummy",
      "filter_1": "true",
      "filter_2": "true"
    }
  },
  {
    "__flb_record_time": 1647959896.404954,
    "record": {
      "message": "dummy",
      "filter_1": "true",
      "filter_2": "true"
    }
  },
  {
    "__flb_record_time": 1647959897.404921,
    "record": {
      "message": "dummy",
      "filter_1": "true",
      "filter_2": "true"
    }
  },
  {
    "__flb_record_time": 1647959898.404947,
    "record": {
      "message": "dummy",
      "filter_1": "true",
      "filter_2": "true"
    }
  }
]
```

These are all available via the web endpoints:
- http://localhost:2020/api/v1/stream_processor/list - list all tasks
- http://localhost:2020/api/v1/stream_processor/task - create a new task from JSON
- http://localhost:2020/api/v1/stream_processor/flush/<task name> - get output from task
