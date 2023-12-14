#!/usr/bin/env bash

# Open an new terminal in the last current working directory, if possible

term=
flag=
# Set defaults
if [ -x "$(command -v gnome-terminal)" ]; then
    term="gnome-terminal"
fi
if [ -x "$(command -v konsole)" ]; then
    term="konsole"
fi
case "$term" in
    konsole )
        flag="--workdir" ;;
    gnome-terminal )
        flag="--working-directory" ;;
esac
args=
cwd=
# Use alacritty if it is present
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
if [ -x "$(command -v alacritty)" ]; then
    term=alacritty
    flag="--working-directory"
else
    >&2 echo "Could not find alacritty"
fi
if [ -d "$HOME/bin" ]; then
    PATH="$PATH:$HOME/bin"
fi
if [ -x "$(command -v lastcwd)" ]; then
    cwd="$(lastcwd)"
    if [ -n "$cwd" ]; then
        # Only set args if cwd could be determined
        args="$flag $cwd"
    fi
else
    >&2 echo "Could not find lastcwd"
fi
$term $args &
