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


# Varialbles
#----------------------------
# User defined variables

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# # Use 256 color terminal.
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LS_COLORS='di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43'

# # Set a fancy prompt (non-color, unless we know we "want" color).
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Set system editor
if hash nvim 2> /dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# Set terminal variable so i3 doesn't launch xterm instead
export TERMINAL=konsole


# Prompt
#----------------------------
# User prompt customization
# Actual prompt formatting
PROMPT="[\\u@\\h: \\W | \\A]\\$ "
PCOLOR=
RESET=
if [[ $OS == Darwin ]]; then
    # Good colors with homebrew scheme:
    # 45
    # 51
    PCOLOR="\[$(tput setaf 45)\]"
    # Reset out of attribute mode
    RESET="\[$(tput sgr0)\]"
    PS1="${PCOLOR}${PROMPT}${RESET}"
elif [ "$color_prompt" == yes ]; then
    PCOLOR="\[$(tput setaf 45)\]"
    RESET="\[$(tput sgr0)\]"
    PS1="${PCOLOR}${PROMPT}${RESET}"
else
    PS1="${PROMPT}"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Alias
#----------------------------
# User aliases

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
alias vimrc="vi ~/.vim/vimrc"
alias spotify="flatpak run com.spotify.Client"

# Open files easily
if hash xdg-open 2> /dev/null; then
    alias op="xdg-open"
fi
if [ "$OS" == "Darwin" ]; then
    alias op="open"
fi

alias py="python"
alias ipy="ipython"


# Functions
#----------------------------
# User defined functions

# function for pretty printing the PATH variable
# usage:
# $ path
function path() {
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}

# Copied from https://github.com/glesica/bash-config
# Append a directory to the PATH if it exists.
function append_to_path() {
    local newpath="$1"
    if [[ ! "$PATH" == *"$newpath"* ]]; then
        export PATH="$PATH:$newpath"
    fi
}

# Prepend a directory to the PATH if it exists.
function prepend_to_path() {
    local newpath="$1"
    if [[ ! "$PATH" == *"$newpath"* ]]; then
        export PATH="$newpath:$PATH"
    fi
}

# Source a file, but only if it exists.
function source_if_exists() {
    local srcpath="$1"
    if [[ -f "$srcpath" ]]; then
        source "$srcpath"
    fi
}

function make_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
}

function get_xserver ()
{
    case $TERM in
        xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
            # Ane-Pieter Wieringa suggests the following alternative:
            #  I_AM=$(who am i)
            #  SERVER=${I_AM#*(}
            #  SERVER=${SERVER%*)}
            XSERVER=${XSERVER%%:*}
            ;;
            aterm | rxvt)
            # Find some code that works here. ...
            ;;
    esac
}


# Environment
#----------------------------
# User system setup

make_dir "$HOME/.local/bin"
make_dir "$HOME/bin"

make_dir "$XDG_CONFIG_HOME"
make_dir "$XDG_CACHE_HOME"
make_dir "$XDG_DATA_HOME"

if [[ $OS != Darwin && -z ${DISPLAY:=""} ]]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
        DISPLAY=":0.0"          # Display on local host.
    else
        DISPLAY=${XSERVER}:0.0     # Display on remote host.
    fi

    export DISPLAY
fi

# Set vim bindings
set -o vi


# Path
#----------------------------
# User additions to he PATH variable

# Rust
prepend_to_path "$HOME/.cargo/bin"

prepend_to_path "$HOME/.local/bin"

# Apple specific
if [[ $OS == Darwin ]]; then
    # Brew Clang
    prepend_to_path "/usr/local/Cellar/llvm/7.0.1/bin"

    # MacGhostView
    append_to_path "/Applications/MacGhostView.app/Contents/Resources/bin"

    # Add android tools to PATH
    prepend_to_path "$HOME/Library/Android/sdk/platform-tools"
fi

# Setting PATH for my bin
prepend_to_path "$HOME/bin"

# Add snaps
append_to_path "/snap/bin"


# ETC
#----------------------------

if [[ -f "$HOME/repos/z/z.sh" ]]; then
    source "$HOME/repos/z/z.sh"
fi

# added by Anaconda3 5.3.1 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '~/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="~/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

export NVM_DIR="$HOME/.config"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
