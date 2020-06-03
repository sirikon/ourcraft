#!/usr/bin/env bash
set -euo pipefail

serviceName="ourcraft"
tempFolder="${OURCRAFT_ROOT}/tmp"

function service-install-command {
	tempServiceFile="${tempFolder}/${serviceName}.service"
	mkdir -p "$tempFolder"
	(
		export USER=$USER
		export GROUP=$USER
		export WORKDIR=$(pwd)
		envsubst < "${OURCRAFT_ROOT}/src/assets/systemd.service" > "${tempServiceFile}"
	)
	sudo mv "${tempServiceFile}" "/etc/systemd/system/${serviceName}.service"
	sudo systemctl enable ${serviceName}
	rm -rf "$tempFolder"
}

function service-remove-command {
	sudo systemctl disable ${serviceName}
	sudo rm "/etc/systemd/system/${serviceName}.service"
}

function service-start-command {
	sudo systemctl start ${serviceName}
}

function service-stop-command {
	sudo systemctl stop ${serviceName}
}

function attach-command {
	screen -r ourcraft
}
