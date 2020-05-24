#!/usr/bin/env bash
set -euo pipefail

configPath="$(pwd)/ourcraft.env"

function load-config {
	if [ ! -f "$configPath" ]; then
		printf "Config file is missing\n"
		exit 1
	fi
	export $(cat ${configPath} | xargs)
}
