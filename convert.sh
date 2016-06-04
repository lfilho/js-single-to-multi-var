#!/usr/bin/env bash

convertFile() {
    file=$@
    echo "➜ Converting var declarations in: $file"
    vim -u ./vimrc \
        -e -s \
        -S ./to-multi-var.vim \
        +SingleToMultiVar \
        +wq \
        "$file"
}

convertDir() {
    dir=$@
    echo "Recursing in the directory: $dir"
    find "$dir" -type f | grep ".js" | while read file; do
        convertFile $file
    done
}

# TODO create doc / examples about this in README:
# If no arg passed, recurse current dir:
if [ $# = 0 ]; then
    convertDir .
    exit 0
fi

# TODO create doc / examples about this in README:
# Accepts multiple args, both files or directories:
while [[ $# > 0 ]]; do
    if [ -n "$1" ] && [ -f "$1" ]; then
        convertFile "$1"
    elif [ -d "$1" ]; then
        convertDir "$1"
    fi
    shift
done

# TODO count number of processed files / directories

exit 0
