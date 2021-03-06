% erl-influx changelog

# Next Version
## Features
- Add `influx:enqueue_point/2`.
- Always add the hostname as tag `host` for all points.
## Bugs
- Fix handling of unknown `gen_server` calls.
## Misc
- `influx_client:start_link/2` and `influx_client:enqueue_point/2` now accept
  client identifiers instead of client references.

# 1.2.0
## Misc
- Replace gun by [erl-mhttp](https://github.com/exograd/erl-mhttp).
- Send points every 2.5 seconds by default, instead of every second.

# 1.1.0
## Features
- The default option map is now `#{}`. `influx_client:default_options/0` is
  therefore useless and has been removed.
## Bugs
- Fix type specification in the `influx_memory_probe` module.

# 1.0.1
## Fixes
- Fix various type specifications.

# 1.0.0
First public version.
