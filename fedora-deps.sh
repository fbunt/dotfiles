#!/usr/bin/env bash

echo "Adding RPMFusion"
# Nvidia drivers and dependencies for buiding everything
dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-29.noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-29.noarch.rpm \

echo "Updating index"
dnf check-update -y

echo "Installing programs and dependencies"
# Programs and libs
dnf install -y \
    xorg-x11-drv-nvidia \
    akmod-nvidia \
    xorg-x11-drv-nvidia-cuda \
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
    i3-ipc \
    i3lock \
    i3status \
    java-11-openjdk \
    kdf \
    make \
    ncdu \
    neovim \
    numlockx \
    ripgrep \
    rofi \
    snapd \
    stow \
    vim \
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


echo "Installing rust"
curl https://sh.rustup.rs -sSf | sh


# git repos needed
echo "Cloning git repos"
mkdir -p "$HOME/repos"
cd "$HOME/repos"

declare -a repos=(
    https://github.com/jwilm/alacritty.git
    https://github.com/rupa/z.git
    https://github.com/stark/siji.git
    https://github.com/tryone144/compton.git
    https://github.com/wknapik/lastcwd.git
    https://www.github.com/Airblader/i3.git
)

for r in "${repos[@]}"; do
    git clone "$r"
done
mv i3 i3-gaps


# Install fonts
echo "Installing fonts"
declare -a inconsolata_files=(
    https://github.com/DeLaGuardo/Inconsolata-LGC/raw/master/inconsolatalgc.ttf
    https://github.com/DeLaGuardo/Inconsolata-LGC/raw/master/inconsolatalgcbold.ttf
    https://github.com/DeLaGuardo/Inconsolata-LGC/raw/master/inconsolatalgcbolditalic.ttf
    https://github.com/DeLaGuardo/Inconsolata-LGC/raw/master/inconsolatalgcitalic.ttf
)

echo "Installing Inconsolata"
font_dir="$HOME/.local/share/fonts/inconsolata-lgc"
mkdir -p "$font_dir"
for url in "${inconsolata_files[@]}"; do
    wget --directory-prefix="$font_dir"  "$url"
done
fc-cache -fv
