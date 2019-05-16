#!/usr/bin/env bash

# Nvidia drivers
add-apt-repository ppa:graphics-drivers/ppa
apt update
apt install -y "$(ubuntu-drivers list | sort | tail -n 1)"

echo "Installing programs and dependencies"
# Programs and libs
apt install -y \
    arandr \
    asciidoc \
    autoconf \
    automake \
    clang \
    cmake \
    cmake-data \
    cowsay \
    dmenu \
    feh \
    git \
    gnome-flashback \
    gnome-flashback-common
    gparted \
    i3 \
    i3-wm \
    i3blocks \
    i3lock \
    i3status \
    imagemagick \
    lm-sensors \
    make \
    ncdu \
    nco \
    neovim \
    nfs-common \
    numlockx \
    openjdk-11-jdk \
    pkg-config \
    playerctl \
    ripgrep \
    rofi \
    shellcheck \
    snapd \
    stow \
    suckless-tools \
    sysstat \
    vim \
    vlc \
    x11-utils \
    xclip \
    zsh \
    build-essential \
    libasound2-dev \
    libcairo2-dev \
    libcogl-pango-dev \
    libconfig-dev \
    libcurl4-gnutls-dev \
    libdbusmenu-glib-dev \
    libev-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libgl1-mesa-dev \
    libjsoncpp-dev \
    libmpdclient-dev \
    libnl-3-dev \
    libnl-genl-3-dev \
    libpango1.0-dev \
    libpcre3-dev \
    libpulse-dev \
    libstartup-notification0-dev \
    libx11-dev \
    libxcb-composite0-dev \
    libxcb-cursor-dev \
    libxcb-ewmh-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-shape0-dev \
    libxcb-util0-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxcb-xrm-dev \
    libxcb-xrm0 \
    libxcb1-dev \
    libxcomposite-dev \
    libxdamage-dev \
    libxfixes-dev \
    libxinerama-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxrandr-dev \
    libyajl-dev \
    libyajl-dev \
    ncurses-dev \
    python-xcbgen \
    wireless-tools \
    xcb-proto

ln -s /lib/x86_64-linux-gnu/libpcre.so.3 /lib/x86_64-linux-gnu/libpcre.so.1
