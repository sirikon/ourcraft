#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname ${BASH_SOURCE[0]})/.."

USER="sirikon"
REPO="ourcraft"
VERSION="$(shards version | tr -d '\n')"

function main {
    create-temp-folder

    printf "Building Ourcraft ${VERSION}..."
    run-silent ./scripts/build.sh
    printf "OK\n"
    
    printf "Packaging into .tar.gz file..."
    artifactFile="ourcraft-${VERSION}-linux-amd64.tar.gz"
    (
        cd ./bin
        tar --create --gzip --file "../tmp/${artifactFile}" *
    )
    printf "OK\n"

    printf "Creating release..."
    github-release release \
        --user "${USER}" \
        --repo "${REPO}" \
        --tag "v${VERSION}" \
        --name "Ourcraft ${VERSION}"
    printf "OK\n"
    
    printf "Uploading file..."
    github-release upload \
        --user "${USER}" \
        --repo "${REPO}" \
        --tag "v${VERSION}" \
        --name "${artifactFile}" \
        --file "./tmp/${artifactFile}"
    printf "OK\n"

    remove-temp-folder
}

function create-temp-folder {
    remove-temp-folder
    mkdir -p ./tmp
}

function remove-temp-folder {
    rm -rf ./tmp
}

function run-silent {
    set +e
    output=$("$@" 2>&1)
    result=$?
    set -e
    if [ "$result" -gt "0" ]; then
        echo "Error while running command:"
        echo "$*"
        printf "%s\n" "$output"
        exit "$result"
    fi
}

main
