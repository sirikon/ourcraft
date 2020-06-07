#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname ${BASH_SOURCE[0]})/.."

crystalCompilerLink="https://github.com/crystal-lang/crystal/releases/download/0.34.0/crystal-0.34.0-1-linux-x86_64.tar.gz"

if ! command -v crystala >/dev/null; then
    printf "Crystal compiler not available.\n"
    printf "Using the one inside ./crystal-compiler.\n"

    if [ ! -d ./crystal-compiler ]; then
        printf "Folder ./crystal-compiler doesn't exist.\n"
        printf "Downloading crystal compiler.\n"

        mkdir -p ./crystal-compiler
        (
            cd ./crystal-compiler
            curl -LQ# "$crystalCompilerLink" --output "./crystal.tar.gz"
            tar --strip-components=1 -xzf crystal.tar.gz
            rm crystal.tar.gz
        )
    fi

    export PATH=$(pwd)/crystal-compiler/bin:${PATH}
fi

rm -r ./bin
shards build --production --release --no-debug
