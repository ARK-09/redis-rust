# redis-rust

My own run at the [CodeCrafters "Build Your Own Redis"](https://github.com/codecrafters-io/build-your-own-redis)
challenge in Rust, tested locally with the official
[redis-tester](https://github.com/codecrafters-io/redis-tester).

## Setup (once)

- Install [Podman](https://podman.io) or Docker. The tester only runs on Linux, so it runs in a container.
- On Windows, use **Git Bash** for the commands below.
- The first `./test.sh` run downloads the Rust image (~1.5 GB) and builds the crates. Later runs take a few seconds.

## Doing a stage

1. Run `./test.sh` to list every stage.
2. Read the instructions in `stages/<stage>.md`, for example `stages/base-01-jm1.md`.
3. Write code in `src/main.rs`.
4. Run that stage's test:

   ```sh
   ./test.sh base-01
   ```

5. Run the earlier stages too, so nothing broke (CodeCrafters does this on every submit):

   ```sh
   ./test.sh base
   ```

Patterns match parts of stage names: `./test.sh base lists-0` runs all base stages, then `lists-01` through `lists-09`.

Stages: base (7) → lists, streams, transactions, optimistic-locking, replication, persistence-rdb,
pub-sub, sorted-sets, geospatial, auth, aof, bitmaps.

## Files

- `src/main.rs`: your Redis server.
- `your_program.sh`: builds and starts the server. The tester runs this script.
- `stages/`: stage instructions from CodeCrafters (MIT, see `stages/LICENSE`).
- `test.sh` + `tester/Dockerfile`: the local test runner. To update the tester, change `TESTER_VERSION`.
- Set `debug: true` in `codecrafters.yml` to see more tester logs.
