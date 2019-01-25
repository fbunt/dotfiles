#!/usr/bin/env bash

killall -p compton

if [ -x "$(which compton)" ]; then
    compton -b --config ~/.config/compton/compton.conf &
else
    >&2 echo "Could not find compton"
fi
