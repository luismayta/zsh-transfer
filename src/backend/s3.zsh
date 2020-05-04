#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function transfer::validation {
    [ -z "${TRANSFER_REPOSITORY}" ] && message_warning "TRANSFER_REPOSITORY is neccesary"
    [ -z "${AWS_ACCESS_KEY_ID}" ] && message_warning "AWS_ACCESS_KEY_ID is neccesary"
    [ -z "${AWS_SECRET_ACCESS_KEY}" ] && message_warning "AWS_SECRET_ACCESS_KEY is neccesary"
    [ -z "${AWS_DEFAULT_REGION}" ] && message_warning "AWS_DEFAULT_REGION is neccesary"
}


# Defines convert file to file and if is directory zip .
function transfer::file::convert {
    local file zipfile filename extension uuid slugname responsefile
    file="${1}"
    transfer::file::exists "${file}"
    filename=$(transfer::file::name "${file}")
    uuid=$(transfer::uuid::value)
    extension=$(transfer::file::extension "${file}")
    slugname="$(transfer::string::slug "${filename}").${uuid}"

    if [ -d "${file}" ]; then
        zipfile="${slugname}.zip"
        cd "$(dirname "${file}")" && zip -9 -r -q "${zipfile}" "${file}"
        echo "${zipfile}"
        return
    fi
    responsefile="${slugname}${extension}"
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
    message_info "File generated: ${file}"
    aws s3 cp "${file}" "${TRANSFER_REPOSITORY}" --acl public-read --expires "$(transfer::date::iso +7d)"
    message_success "File upload: ${file}"
    transfer::file::exists "${file}" && rm -rf "${file}" && message_success "file deleted ${file}"
}

transfer::validation