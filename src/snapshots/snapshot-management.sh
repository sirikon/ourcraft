#!/usr/bin/env bash
set -euo pipefail

snapshotsFolder="${OURCRAFT_ROOT}/snapshots"
serverFolder="${OURCRAFT_ROOT}/server"

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
