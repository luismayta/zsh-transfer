#!/usr/bin/env zsh
# -*- coding: utf-8 -*-

#
# Defines transfer alias and provides easy command line file and folder sharing.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#

curl --version 2>&1 > /dev/null
if [ $? -ne 0 ]; then
    echo "Could not find curl."
    return 1
fi

transfer() {
    local curl="curl --progress-bar --upload-file"
    if [ $# -eq 0 ];
    then
        echo "No arguments specified. Usage:\ntransfer /tmp/file.rst\ncat /tmp/file.rst | transfer file.rst"
        return 1
    fi

    tmpfile=$( mktemp -t transferXXX )
    file=$1

    if tty -s;
    then
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi

        if [ -d $file ];
        then
            zipfile=$( mktemp -t transferXXX.zip )
            cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
            $curl "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
            rm -f "$zipfile"
        else
            $curl "$file" "https://transfer.sh/$basefile" >> $tmpfile
        fi
    else
        $curl "-" "https://transfer.sh/$file" >> $tmpfile
    fi

    # cat output link
    cat $tmpfile

    # cleanup
    rm -f $tmpfile
}
