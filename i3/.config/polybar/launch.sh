#!/usr/bin/env bash
# Terminate if already running
killall -p polybar

# Create an instance for each monitor
for m in $(polybar -m | cut -d':' -f1); do
    MONITOR=$m polybar --reload bar &
done
