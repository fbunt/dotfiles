#!/usr/bin/env bash

# Default to konsole
term=konsole
flag="--workdir"
args=
cwd=
# Use alacritty if it is present
if [ -x "$(command -v alacritty)" ]; then
    term=alacritty
    flag="--working-directory"
fi
if [ -x "$(command -v lastcwd)" ]; then
    cwd="$(lastcwd)"
    if [ -n "$cwd" ]; then
        # Only set args if cwd could be determined
        args="$flag $cwd"
    fi
fi
$term $args &
