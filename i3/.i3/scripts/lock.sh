#!/usr/bin/env bash

# i3lock treats multiple monitors as a single screen and tries to use a single
# image without resizing to cover all of them. This script tries to stitch
# resized copies of the lock screen image together such that the original
# appears to have been rendered for each screen.
#
# Ex: A large monitor with a smaller monitor on either side
# Lock image     i3lock output
#   ______       ____________
#   | /\ |  ==>  |O|| /\ ||O|
#   | \/ |       ---| \/ |---
#   ------          ------

lock_dir="$HOME/.i3/lock"
full_img="$lock_dir/lock_full.png"
img_out="$lock_dir/lock"
# Input image names for convert
params=
# For each screen resolution, create an image to fit it
while read line; do
    res=$(echo $line | cut -d" " -f3 | cut -d"+" -f1)

    # Create image for the screen
    screen_img="$lock_dir/lock_${res}.png"
    if [ ! -f "$screen_img" ]; then
        convert "$full_img" -resize $res "$screen_img"
    fi
    params="$params ${screen_img}"
    img_out="${img_out}_${res}"
done <<< "$(xrandr | grep " connected")"
# Final image name
img_out="${img_out}.png"
# Create the final image if it doesn't already exist
if [ ! -f "$img_out" ]; then
    convert $params +append $img_out
fi
/usr/bin/i3lock -i $img_out -t
