#!/usr/bin/env bash
set -euo pipefail

MC_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"
JAVA_VERSION="jdk8u252-j9"
SERVER_JAR="forge-1.12.2-14.23.5.2854.jar"
MEMORY="3g"

export JAVA_HOME="${MC_ROOT}/java/${JAVA_VERSION}"
export PATH="$PATH:${JAVA_HOME}/bin"

(
	cd "${MC_ROOT}/server"
	java \
        -Xmx${MEMORY} -Xms${MEMORY} \
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
