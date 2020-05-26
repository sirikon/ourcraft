#!/usr/bin/env bash
set -euo pipefail

backupFolder="$(pwd)/backup"
serverFolder="$(pwd)/server"
passwordFile="${stateFolder}/backups-password"

function restic-command {
    run-restic $@
}

function backup-command {
    if [ ! -d "$serverFolder" ]; then
        printf "Server folder does not exist\n"
        exit 1
    fi

    if [ ! -f "$passwordFile" ]; then
        mkdir -p $(dirname $passwordFile)
        printf "ourcraft" > $passwordFile
    fi

    if [ ! -d "$backupFolder" ]; then
        printf "Initializing backup directory...\n"
        run-silent run-restic init
    fi

    (cd "$serverFolder" && run-restic backup .)
}

function run-restic {
    restic --repo "$backupFolder" --password-file "$passwordFile" $@
}
