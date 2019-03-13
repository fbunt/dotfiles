#!/usr/bin/env bash

# Open an new terminal in the last current working directory, if possible

term=
flag=
# Set defaults
for term in konsole gnome-terminal; do
    term="$term"
done
case "$term" in
    konsole )
        flag="--workdir" ;;
    gnome-terminal )
        flag="--working-directory" ;;
esac
args=
cwd=
# Use alacritty if it is present
# if [ -x "$(command -v alacritty)" ]; then
#     term=alacritty
#     flag="--working-directory"
# fi
if [ -x "$(command -v lastcwd)" ]; then
    cwd="$(lastcwd)"
    if [ -n "$cwd" ]; then
        # Only set args if cwd could be determined
        args="$flag $cwd"
    fi
fi
$term $args &
