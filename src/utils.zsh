#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# get extension of file
function transfer::file::extension {
    local extension filename
    filename="${1}"
    transfer::file::exists "${filename}"
    extension="$(echo "${filename}" | awk -F . '{print $NF}')"
    echo ".${extension}"
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
