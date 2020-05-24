#!/usr/bin/env bash
set -euo pipefail
cd $(dirname ${BASH_SOURCE[0]})
(
	export BIN_PATH="$(pwd)/bin/ourcraft"
	envsubst < ./assets/bin-link > /usr/local/bin/ourcraft
	chmod +x /usr/local/bin/ourcraft
)
