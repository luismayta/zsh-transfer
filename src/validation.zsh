#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# get extension of file
function transfer::file::exists {
    local filename
    filename="${1}"
    if [ ! -e "${filename}" ]; then
        message_warning "File ${filename} doesn't exists."
        return
    fi
}
