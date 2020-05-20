#!/usr/bin/env bash
set -euo pipefail

MC_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]})/..)"
SERVER_JAR="forge-1.12.2-14.23.5.2854.jar"
MEMORY="3g"

source "${MC_ROOT}/src/java-management.sh"

function main {
    command="${1:-"help"}"
    args="${@:2}"
    case "$command" in
        start) start-command ;;
        switch-java) switch-java-command "$args" ;;
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
                    -Xmx${MEMORY} -Xms${MEMORY} \
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

main $@
