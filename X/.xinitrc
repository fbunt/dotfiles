#!/bin/bash
# Merge colors and settings
xrdb -merge ~/.Xresources

xset +fp $HOME/.local/share/fonts
xset fp rehash
