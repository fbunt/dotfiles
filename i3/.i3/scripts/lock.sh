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

wallpaper="$HOME/.i3/wallpaper/wallpaper.png"
lock_cache="$HOME/.cache/lock_cache"
full_img="$lock_cache/wp_blur.png"
blur="0x40"
# Final image used by i3lock
img_out="$lock_cache/lock.png"
# Input image names for convert
screen_imgs=

if [ ! -d "$lock_cache" ]; then
    mkdir -p "$lock_cache"
fi
# Create blurred version of wallpaper to use as lock screen
if [ ! -f "$full_img" ]; then
    if [ -f "$wallpaper" ]; then
        convert "$wallpaper" -blur "$blur" "$full_img"
    else
        # No wallpaper found so just use default i3lock
        /usr/bin/i3lock
        exit
    fi
fi

# For each screen resolution, create an image to fit it
while read -r line; do
    res=$(echo "$line" | awk '{print $1}')

    # Create image for the screen
    screen_img="$lock_cache/lock_${res}.png"
    if [ ! -f "$screen_img" ]; then
        # Resize and crop the image to fit the resolution and add prompt text
        convert "$full_img" -resize "${res}^" -gravity center -extent "$res" \
            -pointsize 50 -fill white -gravity center -annotate +0+200 \
            "What's the password?" "$screen_img"
    fi
    screen_imgs="$screen_imgs ${screen_img}"
done <<< "$(xrandr | grep "\*")"
# Create the final image if it doesn't already exist
if [ ! -f "$img_out" ]; then
    convert $screen_imgs +append "$img_out"
fi
/usr/bin/i3lock -i "$img_out" -t
