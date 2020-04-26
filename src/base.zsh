#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# curl::install - install curl
function curl::install {
    if ! type -p brew > /dev/null; then
        message_warning "${FUNCTIONS_MESSAGE_BREW}"
        return
    fi
    message_info "Install curl"
    brew install curl
    message_success "Installed curl"
}

if ! type -p curl > /dev/null; then curl::install; fi
