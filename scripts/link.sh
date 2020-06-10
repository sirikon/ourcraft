#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname ${BASH_SOURCE[0]})/.."

echo "Linking ourcraft in ./bin/ourcraft to /usr/local/bin/ourcraft"
rm -f /usr/local/bin/ourcraft
ln -s $(pwd)/bin/ourcraft /usr/local/bin/ourcraft
