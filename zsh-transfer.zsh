#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines transfer alias and provides easy command line file and folder sharing.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#
#
TRANSFER_PLUGIN_DIR="$(dirname "${0}")"
TRANSFER_SOURCE_PATH="${TRANSFER_PLUGIN_DIR}"/src
TRANSFER_BACKEND_PATH="${TRANSFER_SOURCE_PATH}"/backend

export TRANSFER_MESSAGE_BREW="Please install brew or use antibody bundle luismayta/zsh-brew branch:develop"
export TRANSFER_MESSAGE_NOT_FOUND="this not found installed"

[ -z "${TRANSFER_REPOSITORY}" ] && export TRANSFER_REPOSITORY="https://transfer.sh"

# shellcheck source=/dev/null
source "${TRANSFER_SOURCE_PATH}"/base.zsh

# shellcheck source=/dev/null
source "${TRANSFER_SOURCE_PATH}"/utils.zsh

# cross::os functions for osx and linux
function cross::os {

    case "${OSTYPE}" in
        darwin*)
            # shellcheck source=/dev/null
            source "${TRANSFER_SOURCE_PATH}"/darwin.zsh
            ;;
        linux*)
            # shellcheck source=/dev/null
            source "${TRANSFER_SOURCE_PATH}"/linux.zsh
            ;;
    esac

}

cross::os

function transfer::factory {
    # shellcheck source=/dev/null
    source "${TRANSFER_BACKEND_PATH}"/s3.zsh
}

transfer::factory
