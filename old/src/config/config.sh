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

function configure-command {
    ask-for "JVM memory" jvmMemory
    ask-for "Server JAR file name" serverJar

    write-config \
        "JVM_MEMORY" $jvmMemory \
        "SERVER_JAR" $serverJar

    mkdir -p "$(pwd)/server"
}

function ask-for {
    printf "$1: "
    read -r $2
}

function write-config {
    printf "%s=%s\n" $@ > $configPath
}
