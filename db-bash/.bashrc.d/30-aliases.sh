# The basics
alias grep='grep --color=auto --exclude-dir=\.git'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
if [[ $OS == Darwin ]]; then
    alias ls='ls -F'
    alias la='ls -aF'
    alias ll='ls -alF'
    alias llh='ls -alFh'
    alias l='ls -F'
else
    alias ls='ls -F --color=auto'
    alias la='ls -aF --color=auto'
    alias ll='ls -alF --color=auto'
    alias llh='ls -alFh --color=auto'
    alias l='ls -F --color=auto'
fi

alias vi="nvim"
# system vi
alias svi="/usr/bin/vi"
alias bashrc="vi ~/.bashrc"
alias vimrc="vi ~/.config/nvim/init.lua"
alias spotify="flatpak run com.spotify.Client"

# Open files easily
if hash xdg-open 2> /dev/null; then
    alias op="xdg-open"
fi
if [ "$(uname -s)" == "Darwin" ]; then
    alias op="open"
fi

alias py="python"
alias ipy="ipython"

alias db="distrobox"
