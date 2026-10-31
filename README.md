# redis-rust

My own run at the [CodeCrafters "Build Your Own Redis"](https://github.com/codecrafters-io/build-your-own-redis)
challenge in Rust, tested locally with the official
[redis-tester](https://github.com/codecrafters-io/redis-tester).

## Setup (once per computer)

On Windows, run everything below in a **Git Bash** you opened yourself (Start menu or VS Code terminal).

1. Install [Podman](https://podman.io) (or Docker). The tester only runs on Linux, so it runs in a container.
2. Create and start the Podman VM:

   ```sh
   podman machine init
   podman machine start
   ```

3. Check that your shell can reach it: `podman system connection list` should show one connection with `Default` set to `true`.

The first `./test.sh` run downloads the Rust image (~1.5 GB) and builds the crates (~3 min). Later runs take a few seconds.

**After each reboot:** run `podman machine start`. If your VM isn't named `podman-machine-default`, add its name (`podman machine list` shows it).

## Troubleshooting

**`Cannot connect to Podman ... dial unix /run/podman/podman.sock`**, while `podman machine start` says "already running":
your shell has no connection to the VM, and `podman system connection list` is empty.
This happens when the VM was created from a packaged Windows app (for example one installed from the Microsoft Store).
Windows stores that app's `AppData` files in a private folder, so your shell never sees the connection.

Fix: recreate the VM from your own Git Bash (~2 min). This also deletes the cached images, so the next `./test.sh` downloads them again.

```sh
podman machine rm -f <name>   # name from `podman machine list`
podman machine init
podman machine start
```

## Doing a stage

1. Run `./test.sh` to list every stage.
2. Read the instructions in `stages/<stage>.md`, for example `stages/base-01-jm1.md`.
3. Write code in `src/main.rs`.
4. Run that stage's test:

   ```sh
   ./test.sh base-01
   ```

5. Run the earlier stages too, so nothing broke (CodeCrafters does this on every submit).
   The tester stops at the first failure, so only list stages you've finished:

   ```sh
   ./test.sh 'base-0[1-3]'
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
