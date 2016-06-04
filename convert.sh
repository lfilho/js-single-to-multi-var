#!/usr/bin/env bash

convertFile() {
    file=$@
    echo "  Converting var declarations: $file"
    vim -u ./vimrc \
        -e -s \
        -S ./to-multi-var.vim \
        +SingleToMultiVar \
        +wq \
        $file
}

find . -type f | grep ".js" | while read file
do
    convertFile $file
done

