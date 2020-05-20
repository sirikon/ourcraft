#!/usr/bin/env bash
set -euo pipefail

snapshotsFolder="${MC_ROOT}/snapshots"
serverFolder="${MC_ROOT}/server"

function create-snapshot-command {
    if [ ! -d "$serverFolder" ]; then
        printf "Server folder does not exist\n"
        exit 1
    fi
    mkdir -p "$snapshotsFolder"
    snapshotName=$(date +'%F-%H-%M-%S')
    (
        cd "${serverFolder}"
        zip -qr "${snapshotsFolder}/${snapshotName}.zip" .
    )
}
