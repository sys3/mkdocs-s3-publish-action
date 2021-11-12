#!/bin/bash

set -e

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

function print_info() {
    echo -e "\e[36mINFO: ${1}\e[m"
}

# configfile
if [ -n "${CONFIG_FILE}" ]; then
    print_info "Setting custom path for mkdocs config yml"
    export CONFIG_FILE="${GITHUB_WORKSPACE}/${CONFIG_FILE}"
else
    export CONFIG_FILE="${GITHUB_WORKSPACE}/mkdocs.yml"
fi

# install mkdocs
if [ -n "${REQUIREMENTS}" ] && [ -f "${GITHUB_WORKSPACE}/${REQUIREMENTS}" ]; then
    pip install -r "${GITHUB_WORKSPACE}/${REQUIREMENTS}"
else
    REQUIREMENTS="${GITHUB_WORKSPACE}/requirements.txt"
    if [ -f "${REQUIREMENTS}" ]; then
        pip install -r "${REQUIREMENTS}"
    fi
fi

# build mkdocs pages
mkdocs build --config-file "${CONFIG_FILE}"

# install minio/client
sudo curl -sfo ./mc -L https://dl.min.io/client/mc/release/linux-amd64/mc
sudo chmod 755 ./mc

# mirror pages to S3 bucket 
./mc alias set site "${S3_LOCATION}" "${S3_ACCESS_KEY}" "${S3_SECRET_KEY}"
./mc mirror --overwrite "${GITHUB_WORKSPACE}/${DOC_SITE:-sites}" "${S3_BUCKET}/${S3_DIR}"
