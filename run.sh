#!/usr/bin/env bash
set -euo pipefail
shards build
(cd testing-folder && ../bin/ourcraft "$@")
