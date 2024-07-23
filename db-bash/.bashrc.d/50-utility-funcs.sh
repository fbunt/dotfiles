# function for pretty printing the PATH variable
# usage:
# $ path
function path() {
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}

# sudo but with user PATH added to super user PATH
function psudo() {
    sudo env PATH="$PATH" "$@";
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
