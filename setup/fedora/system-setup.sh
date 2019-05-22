#!/usr/bin/env bash

echo "Adding RPMFusion"
# Nvidia drivers and dependencies for buiding everything
dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-29.noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-29.noarch.rpm \

echo "Updating index"
dnf check-update -y

# Nvidia drivers
dnf install -y \
    xorg-x11-drv-nvidia \
    akmod-nvidia \
    xorg-x11-drv-nvidia-cuda

echo "Installing programs and dependencies"
# Programs and libs
dnf install -y \
    ImageMagick \
    ShellCheck \
    arandr \
    asciidoc \
    automake \
    clang \
    cmake \
    cowsay \
    dmenu \
    fd-find \
    feh \
    gcc \
    git \
    i3lock \
    i3status \
    java-11-openjdk \
    kdf \
    lm_sensors \
    make \
    ncdu \
    nco \
    neovim \
    numlockx \
    perl-Env \
    perl-Time-HiRes \
    ripgrep \
    rofi \
    snapd \
    stow \
    sysstat \
    vim \
    vlc \
    xclip \
    zsh \
    @development-tools \
    alsa-lib-devel \
    cairo-devel \
    fontconfig-devel \
    freetype-devel \
    jsoncpp-devel \
    libX11-devel \
    libXcomposite-devel \
    libXdamage-devel \
    libXfixes-devel \
    libXinerama-devel \
    libXrandr-devel \
    libconfig-devel \
    libcurl-devel \
    libdbusmenu-devel \
    libev-devel \
    libmpdclient \
    libmpdclient-devel \
    libnl3-devel \
    libxcb-devel \
    libxkbcommon-devel \
    libxkbcommon-x11-devel \
    mesa-libGL-devel \
    ncurses-devel \
    pango-devel \
    pcre-devel \
    pulseaudio-libs-devel \
    startup-notification-devel \
    wireless-tools-devel \
    xcb-proto \
    xcb-util-cursor-devel \
    xcb-util-devel \
    xcb-util-image-devel \
    xcb-util-keysyms-devel \
    xcb-util-wm-devel \
    xcb-util-xrm-devel \
    yajl-devel

player_ver=2.0.1
wget -P /tmp/ https://github.com/acrisci/playerctl/releases/download/v${player_ver}/playerctl-${player_ver}_x86_64.rpm
dnf install -y /tmp/playerctl-${player_ver}_x86_64.rpm