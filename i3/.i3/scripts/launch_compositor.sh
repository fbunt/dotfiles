#!/usr/bin/env bash

killall picom

if [ -x "$(which picom)" ]; then
    picom -b --experimental-backends &
else
    >&2 echo "Could not find picom"
fi
