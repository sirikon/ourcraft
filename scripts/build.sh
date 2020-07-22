#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

rm -rf ./bin
(cd spa && npm install && npm run build)
shards build --production --release --no-debug
