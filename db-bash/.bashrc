# ~/.bashrc

# Much of this is taken from the default debian .bashrc

# Set these here so that non-interactive sessions still see them
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

OS=$(uname -s)

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
