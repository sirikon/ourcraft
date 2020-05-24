#!/usr/bin/env bash
set -euo pipefail

function import {
    importPath="$1"
    source "${OURCRAFT_ROOT}/src/${importPath}"
}

function get-asset {
	assetPath="$1"
	cat "${OURCRAFT_ROOT}/src/assets/${assetPath}"
}

function run-silent {
    set +e
    output=$("$@" 2>&1)
    result=$?
    set -e
    if [ "$result" -gt "0" ]; then
        printf "Error while running command:\n"
        printf "$*"
        printf "%s\n" "$output"
        exit "$result"
    fi
}

function load-config {
	configPath="$(pwd)/ourcraft.env"
	if [ ! -f "$configPath" ]; then
		printf "Config file is missing\n"
		exit 1
	fi
	export $(cat ${configPath} | xargs)
}

import "config/config.sh"
import "java/java-management.sh"
import "systemd/service-management.sh"
import "snapshots/snapshot-management.sh"
