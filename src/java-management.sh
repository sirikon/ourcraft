#!/usr/bin/env bash
set -euo pipefail

javaVersionsPath="${MC_ROOT}/src/assets/java-versions"
stateFolder="${MC_ROOT}/state"
currentJavaVersionfile="${stateFolder}/current-java-version"

function switch-java-command {
    javaVersion="${1:-""}"
    currentJavaVersion=$(get-current-java-version)

    if [ "$javaVersion" == "" ]; then
        printf "Choose an available version:\n"
        cat $javaVersionsPath | while read -r version link
        do
            check=" "
            if [ "$currentJavaVersion" == "$version" ]; then
                check="x"
            fi
            printf "[$check] $version\n"
        done
        printf "\nSwitch to a new one with 'ourcraft switch-java <version>'\n"
    else
        ensure-java-downloaded "$javaVersion"
        set-current-java-version "$javaVersion"
    fi
}

function ensure-java-downloaded {
    javaVersion="$1"
    javaVersionLink=$(get-java-version-link "$javaVersion")
    javaFolder="${MC_ROOT}/java/${javaVersion}"
    if [ ! -d "$javaFolder" ]; then
        mkdir -p "$javaFolder"
        curl -LQ --progress-bar "$javaVersionLink" --output "$javaFolder/java.tar.gz"
        (
            cd "$javaFolder"
            tar --strip-components=1 -xzf java.tar.gz
            rm java.tar.gz
        )
    fi
}

function get-java-version-link {
    javaVersion="$1"
    awk -v javaVersion="$javaVersion" '{if($1 == javaVersion){print $2}}' src/assets/java-versions | head -n 1
}

function set-current-java-version {
    javaVersion="$1"
    mkdir -p "${stateFolder}"
    printf "$javaVersion" > "${stateFolder}/current-java-version"
}

function get-current-java-version {
	if [ -f "$currentJavaVersionfile" ]; then
		cat "${stateFolder}/current-java-version"
	fi
}




