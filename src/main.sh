#!/usr/bin/env bash
set -euo pipefail

MC_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]})/..)"

source "${MC_ROOT}/src/java-management.sh"
source "${MC_ROOT}/src/service-management.sh"
source "${MC_ROOT}/src/snapshot-management.sh"

configPath="${MC_ROOT}/config.env"

function main {
	load-config
	command="${1:-"help"}"
	args="${@:2}"
	case "$command" in
		start) start-command ;;
		switch-java) switch-java-command "$args" ;;
		create-service) create-service-command ;;
		create-snapshot) create-snapshot-command ;;
		help) help-command ;;
		*) unknown-command "$command" ;;
	esac
}

function start-command {
	JAVA_VERSION="$(get-current-java-version)"
	(
		export JAVA_HOME="${MC_ROOT}/java/${JAVA_VERSION}"
		export PATH="$PATH:${JAVA_HOME}/bin"
		cd "${MC_ROOT}/server"
		java \
			-Xmx${JVM_MEMORY} -Xms${JVM_MEMORY} \
			-XX:+UnlockExperimentalVMOptions \
			-XX:+AlwaysPreTouch \
			-XX:+UseG1GC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 \
			-XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 \
			-XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
			-XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
			-XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC \
			-XX:InitiatingHeapOccupancyPercent=15 \
			-XX:G1MixedGCLiveThresholdPercent=90 \
			-XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 \
			-XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
			-jar $SERVER_JAR
	)
}

function help-command {
	printf "You're alone, buddy.\n"
}

function unknown-command {
	printf "Unknown command '%s'\n" "$1"
}

function load-config {
	if [ ! -f "$configPath" ]; then
		printf "Config file is missing\n"
		exit 1
	fi
	export $(cat ${configPath} | xargs)
}

main $@
