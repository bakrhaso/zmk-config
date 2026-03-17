#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
podman run --rm -v .:/workspace:Z zmk-build "$@"
