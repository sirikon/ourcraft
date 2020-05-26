#!/usr/bin/env bash
set -euo pipefail

cd $(dirname ${BASH_SOURCE[0]})

function main {
	printf ":: Installing apt dependencies\n"
	apt-get install -y restic

	printf ":: Installing ourcraft\n"
	(
		export BIN_PATH="$(pwd)/bin/ourcraft"
		envsubst < ./assets/bin-link > /usr/local/bin/ourcraft
		chmod +x /usr/local/bin/ourcraft
	)
	printf ":: Done!\n"
}

main $@
