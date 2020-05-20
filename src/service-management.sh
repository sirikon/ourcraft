#!/usr/bin/env bash
set -euo pipefail

tempFolder="${MC_ROOT}/tmp"

function create-service-command {
    serviceName="ourcraft"
    tempServiceFile="${tempFolder}/${serviceName}.service"
    mkdir -p "$tempFolder"
    (
        export USER=$USER
        export GROUP=$USER
        export ROOT=$MC_ROOT
        envsubst < "${MC_ROOT}/src/assets/systemd.service" > "${tempServiceFile}"
    )
    sudo mv "${tempServiceFile}" "/etc/systemd/system/${serviceName}.service"
    sudo systemctl enable ${serviceName}
    rm -rf "$tempFolder"
}
