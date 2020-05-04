#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# show value for uuid
function transfer::uuid::value {
    openssl rand -hex 4
}


# get extension of file
function transfer::file::extension {
    local extension filename
    filename="${1}"
    transfer::file::exists "${filename}"
    extension="$(echo "${filename}" | awk -F . '{if (NF>1) {print $NF}}')"
    if [ -n "${extension}" ]; then
        echo ".${extension}"
    fi
}

# get name of file
function transfer::file::name {
    local filename basefile extension
    filename="${1}"
    transfer::file::exists "${filename}"
    extension="$(transfer::file::extension "${filename}")"
    basefile="$(basename "${filename}" "${extension}")"
    echo "${basefile}"
}

# convert string to slug
function transfer::string::slug {
    local data slug
    data="${1}"
    slug="$(echo "${data}" | sed -e 's/[^a-zA-Z0-9._-]/-/g')"
    echo "${slug}"
}

# get file slug
function transfer::file::slug {
    local file filename
    file="${1}"
    transfer::file::exists "${file}"
    filename=$(transfer::string::slug "${file}")
    transfer::string::slug "${filename}"
}

function transfer::date::iso {
    local format_date expiry_date expiry_days
    format_date="%Y-%m-%dT%H:%M:%SZ"
    expiry_days="${1}"
    if [ -z "${expiry_days}" ]; then
        message_warning "please add one value"
        return
    fi

    if [ "$(uname)" = "Darwin" ]; then
        expiry_date=$( date -u -v "${expiry_days}" +"${format_date}")
        echo "${expiry_date}"
        return
    fi
    expiry_date=$( date -u -d "${expiry_days}" +"${format_date}")
    echo "${expiry_date}"
}