#!/bin/bash

if [ -z $1 ]; then
    echo "Too few arguments."
    echo "Please specify whether you want to prune (p),"
    echo "keep (k) or move (m) some files in your repository."
    exit 1
fi

if [[ ! -f ~/file-list.txt && "$1" != "m" ]]; then
    echo "Error."
    echo "Please put the list of the files you want"
    echo "to prune/keep in ~/file-list.txt."
    exit 1
fi

if [ "$1" == "p" ]; then
    git filter-branch --prune-empty --index-filter \
    '$MY_SCRIPTS/git-prune-files.sh ~/file-list.txt' \
    -- --all
fi

if [ "$1" == "k" ]; then
    git filter-branch --prune-empty --index-filter \
    '$MY_SCRIPTS/git-keep-files.sh ~/file-list.txt' \
    -- --all
fi

if [ "$1" == "m" ]; then
    if [ -z "$3" ]; then
        echo "Error: too few arguments."
        echo "Please specify what to move (\$2) and the target (\$3)."
        exit 1
    else
        echo "Paths should be double-quoted to avoid trouble."
        echo " "
        # index-filter is behaving very weirdly,
        # that's why i use tree-filter.
        git filter-branch -f --prune-empty --tree-filter \
        "$MY_SCRIPTS/move-files.py \"$2\" \"$3\"" \
        -- --all
    fi
fi