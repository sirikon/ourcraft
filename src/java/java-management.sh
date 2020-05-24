#!/usr/bin/env bash
set -euo pipefail

stateFolder="$(pwd)/state"
currentJavaVersionfile="${stateFolder}/current-java-version"

function java-list-command {
	currentJavaVersion=$(get-current-java-version)
	printf "Choose an available version:\n"
	get-asset "java-versions" | while read -r version link
	do
		check=" "
		if [ "$currentJavaVersion" == "$version" ]; then
			check="x"
		fi
		printf "[$check] $version\n"
	done
	printf "\nSwitch to a new one with 'ourcraft switch-java <version>'\n"
}

function java-use-command {
	javaVersion="${1}"
	currentJavaVersion=$(get-current-java-version)
	ensure-java-downloaded "$javaVersion"
	set-current-java-version "$javaVersion"
}

function ensure-java-downloaded {
	javaVersion="$1"
	javaVersionLink=$(get-java-version-link "$javaVersion")
	javaFolder="$(pwd)/java/${javaVersion}"
	if [ ! -d "$javaFolder" ]; then
		printf "Java version '${javaVersion}' is not installed. Downloading...\n"
		mkdir -p "$javaFolder"
		run-silent curl -LQ --progress-bar "$javaVersionLink" --output "$javaFolder/java.tar.gz"
		(
			cd "$javaFolder"
			printf "Extracting...\n"
			run-silent tar --strip-components=1 -xzf java.tar.gz
			rm java.tar.gz
			printf "Installed.\n"
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
