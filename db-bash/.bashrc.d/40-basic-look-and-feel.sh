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

# Set a fancy prompt (non-color, unless we know we "want" color).
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned off by default to not distract the user: the focus in a terminal window
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
    PROMPT=$PS1
    PS1="${PCOLOR}${PROMPT}${RESET}"
else
    # PS1="${PROMPT}"
    PS1="${PS1}"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Set vim bindings
set -o vi

# Set system editor
if hash nvim 2> /dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

