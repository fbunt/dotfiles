#!/usr/bin/env bash

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


echo "Fetching anaconda installer"
cd $HOME/Downloads
wget https://repo.anaconda.com/archive/Anaconda3-2018.12-Linux-x86_64.sh
