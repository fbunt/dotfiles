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
screen_imgs=
# For each screen resolution, create an image to fit it
while read line; do
    res=$(echo $line | awk '{print $1}')

    # Create image for the screen
    screen_img="$lock_dir/lock_${res}.png"
    if [ ! -f "$screen_img" ]; then
        # Resize and crop the image to fit the resolution and add prompt text
        convert "$full_img" -resize "${res}^" -gravity center -extent "$res" \
            -pointsize 50 -fill white -gravity center -annotate +0+200 \
            "What's the password?" "$screen_img"
    fi
    screen_imgs="$screen_imgs ${screen_img}"
    img_out="${img_out}_${res}"
done <<< "$(xrandr | grep \*)"
# Final image name
img_out="${img_out}.png"
# Create the final image if it doesn't already exist
if [ ! -f "$img_out" ]; then
    convert $screen_imgs +append $img_out
fi
/usr/bin/i3lock -i $img_out -t
