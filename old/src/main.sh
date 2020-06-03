#!/usr/bin/env bash
set -euo pipefail

OURCRAFT_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]})/..)"
source "${OURCRAFT_ROOT}/src/index.sh"

function main {
	command="${1:-"help"}"
	args="${@:2}"
	case "$command" in
		configure) configure-command ;;
		java-list) java-list-command ;;
		java-use) java-use-command "$args" ;;
		start) start-command ;;
		service-install) service-install-command ;;
		service-remove) service-remove-command ;;
		service-start) service-start-command ;;
		service-stop) service-stop-command ;;
		attach) attach-command ;;
		backup) backup-command ;;
		restic) restic-command "$args" ;;
		help) help-command ;;
		*) unknown-command "$command" ;;
	esac
}

function help-command {
	get-asset "help"
}

function start-command {
	load-config
	JAVA_VERSION="$(get-current-java-version)"
	(
		export JAVA_HOME="$(pwd)/java/${JAVA_VERSION}"
		export PATH="${JAVA_HOME}/bin:$PATH"
		cd "$(pwd)/server"
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
			-jar $SERVER_JAR -nogui
	)
}

function unknown-command {
	printf "Unknown command '%s'\n" "$1"
	printf "See help: ourcraft help\n"
}

main $@
