#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname ${BASH_SOURCE[0]})/.."

echo "Installing ourcraft in /usr/local/bin/ourcraft"
rm -f /usr/local/bin/ourcraft
cp ./bin/ourcraft /usr/local/bin/ourcraft
