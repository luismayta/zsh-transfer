#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function transfer::validation {
    [ -z "${TRANSFER_REPOSITORY}" ] && message_warning "TRANSFER_REPOSITORY is neccesary"
    [ -z "${AWS_ACCESS_KEY_ID}" ] && message_warning "AWS_ACCESS_KEY_ID is neccesary"
    [ -z "${AWS_SECRET_ACCESS_KEY}" ] && message_warning "AWS_SECRET_ACCESS_KEY is neccesary"
    [ -z "${AWS_DEFAULT_REGION}" ] && message_warning "AWS_DEFAULT_REGION is neccesary"
}

function transfer::file::slug {
    local file basefile
    file="${1}"
    basefile="$(basename "${file}" | sed -e 's/[^a-zA-Z0-9._-]/-/g')"
    echo "${basefile}"
}

# Defines convert file to file and if is directory zip .
function transfer::file::convert {
    local file zipfile slugfile
    file="${1}"
    if [ ! -e "${file}" ]; then
        message_warning "File ${file} doesn't exists."
        return
    fi
    slugfile=$(transfer::file::slug "${file}")

    if [ -d "${file}" ]; then
        zipfile=$( mktemp -t "${slugfile}".zip )
        cd "$(dirname "${file}")" && zip -9 -r -q "${zipfile}" "${file}"
        echo "${zipfile}"
        return
    fi
    responsefile=$( mktemp -t "${slugfile}")
    cd "$(dirname "${file}")" && cp -rf "${file}" "${responsefile}"
    echo "${responsefile}"
}

# Defines transfer alias and provides easy command line file and folder sharing.
function transfer {
    local file
    if [ $# -eq 0 ]; then
        message_warning "No arguments specified. Usage:\ntransfer /tmp/file.rst\ncat /tmp/file.rst | transfer file.rst"
        return
    fi
    file=$(transfer::file::convert "${1}")
    aws s3 cp "${file}" "${TRANSFER_REPOSITORY}" --acl public-read
}

transfer::validation