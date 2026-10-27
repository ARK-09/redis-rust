#!/usr/bin/env bash
# Runs CodeCrafters' official redis-tester against this repo, inside a container.
#
#   ./test.sh                 list stages
#   ./test.sh base-05         one stage (instructions: stages/base-05-qq0.md)
#   ./test.sh base            every stage whose name contains "base"
#   ./test.sh base lists-0    several patterns, run in order
set -euo pipefail
cd "$(dirname "$0")"

if [ $# -eq 0 ]; then
  for f in stages/*.md; do printf '%-26s %s\n' "$(basename "$f" .md)" "$(head -1 "$f" | cut -c3-)"; done
  exit
fi

if [ -z "${TESTER_DIR:-}" ]; then
  # Host: build the tester image (cached after the first run), then rerun this script inside it.
  engine=$(command -v podman || command -v docker) || { echo "install podman or docker first" >&2; exit 1; }
  export MSYS_NO_PATHCONV=1 # stop Git Bash rewriting /app etc. into Windows paths
  "$engine" build -q -t redis-local-tester tester >/dev/null
  exec "$engine" run --rm --init \
    -v "$(pwd -W 2>/dev/null || pwd):/app" -w /app \
    -v redis-tester-cargo:/usr/local/cargo/registry \
    -v redis-tester-target:/tmp/codecrafters-build-redis-rust \
    redis-local-tester ./test.sh "$@"
fi

# Container: turn the patterns into the tester's test-case list, compile, run.
cases=""
for pat in "$@"; do
  matches=(stages/*"$pat"*.md)
  [ -e "${matches[0]}" ] || { echo "no stage matches '$pat', run ./test.sh to list them" >&2; exit 1; }
  for f in "${matches[@]}"; do
    n=$(basename "$f" .md)
    cases+="${cases:+,}{\"slug\":\"${n##*-}\",\"tester_log_prefix\":\"$n\",\"title\":\"$n: $(head -1 "$f" | cut -c3-)\"}"
  done
done

.codecrafters/compile.sh
CODECRAFTERS_REPOSITORY_DIR=/app CODECRAFTERS_TEST_CASES_JSON="[$cases]" exec "$TESTER_DIR/tester"
