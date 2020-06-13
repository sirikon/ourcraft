#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname ${BASH_SOURCE[0]})/.."

USER="sirikon"
REPO="ourcraft"
VERSION="$(shards version | tr -d '\n')"

TEMP_FOLDER="./tmp"
TAR_PACKAGE_FILE="${TEMP_FOLDER}/ourcraft-${VERSION}-linux-amd64.tar.gz"
DEB_PACKAGE_FILE="${TEMP_FOLDER}/ourcraft-${VERSION}-linux-amd64.deb"

function main {
    create-temp-folder

    build-ourcraft

    package-tar
    package-deb

    if [ ! "${1:-""}" = "--dry-run" ]; then
        create-release
        upload-file ${TAR_PACKAGE_FILE}
        upload-file ${DEB_PACKAGE_FILE}
        remove-temp-folder
    fi
}

function build-ourcraft {
    printf "Building Ourcraft ${VERSION}..."
    run-silent ./scripts/build.sh
    printf " OK\n"
}

function package-tar {
    printf "Packaging into .tar.gz file..."
    (
        cd ./bin
        tar --create --gzip --file "../${TAR_PACKAGE_FILE}" *
    )
    printf " OK\n"
}

function package-deb {(
    printf "Packaging into deb file..."
    mkdir -p pkg/deb/ourcraft/usr/bin/
    cp ./bin/* pkg/deb/ourcraft/usr/bin/
    (
        cd pkg/deb
        mkdir -p ourcraft/DEBIAN
        export VERSION=${VERSION}
        envsubst < assets/control > ourcraft/DEBIAN/control
        run-silent dpkg-deb --build ourcraft
        mv ./ourcraft.deb "../../${DEB_PACKAGE_FILE}"
    )
    printf " OK\n"
)}

function create-release {
    printf "Creating release..."
    github-release release \
        --user "${USER}" \
        --repo "${REPO}" \
        --tag "v${VERSION}" \
        --name "Ourcraft ${VERSION}"
    printf " OK\n"
}

function upload-file {
    file="$1"
    fileName="$(basename ${file})"
    printf "Uploading ${fileName}..."
    github-release upload \
        --user "${USER}" \
        --repo "${REPO}" \
        --tag "v${VERSION}" \
        --name "${fileName}" \
        --file "${file}"
    printf " OK\n"
}

function create-temp-folder {
    remove-temp-folder
    mkdir -p "${TEMP_FOLDER}"
}

function remove-temp-folder {
    rm -rf "${TEMP_FOLDER}"
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

main "$@"
