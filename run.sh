#!/usr/bin/env bash
set -euo pipefail
(cd testing-folder && crystal ../src/main.cr -- "$@")
