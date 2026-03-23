#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

IMAGE=localhost/zmk-build

podman build -q -t "$IMAGE" -f Containerfile .
podman run --rm -v .:/workspace:Z "$IMAGE" sh -c '[ -d .west ] || just init; "$@"' -- "$@"
