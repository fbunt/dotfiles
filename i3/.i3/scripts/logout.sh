#!/usr/bin/env bash
if [[ "$(~/.i3/scripts/get_desktop.sh)" == *"gnome"* ]]; then
    gnome-session-quit --force --logout
else
    i3-msg exit
fi
