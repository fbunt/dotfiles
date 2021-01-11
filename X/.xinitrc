#!/bin/bash
# Merge colors and settings
if [ -f "$HOME/.Xresources" ]; then
    xrdb -merge ~/.Xresources
fi

xset -dpms
xset s off

mkfontdir "$HOME/.local/share/fonts"
xset +fp "$HOME/.local/share/fonts"
xset fp rehash
