#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname ${BASH_SOURCE[0]})/.."

rm -rf ./bin
shards build --production --release --no-debug
