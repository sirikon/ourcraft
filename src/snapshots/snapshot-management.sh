#!/usr/bin/env bash
set -euo pipefail

snapshotsFolder="$(pwd)/snapshots"
serverFolder="$(pwd)/server"

function snapshot-command {
    if [ ! -d "$serverFolder" ]; then
        printf "Server folder does not exist\n"
        exit 1
    fi
    mkdir -p "$snapshotsFolder"
    snapshotName=$(date +'%F-%H-%M-%S')
    (cd "${serverFolder}" && zip -qr "${snapshotsFolder}/${snapshotName}.zip" .)
}
