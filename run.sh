#!/usr/bin/env bash
shards build
(cd testing-folder && ../bin/ourcraft "$@")
