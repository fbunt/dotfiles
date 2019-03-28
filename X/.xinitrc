#!/bin/bash
# Merge colors and settings
if [ -f "$HOME/.Xresources" ]; then
    xrdb -merge ~/.Xresources
fi

xset +fp "$HOME/.local/share/fonts"
xset fp rehash
