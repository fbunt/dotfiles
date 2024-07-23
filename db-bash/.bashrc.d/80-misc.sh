# Set terminal variable so i3 doesn't launch xterm instead
export TERMINAL=foot

if [[ $OS != Darwin && -z ${DISPLAY:=""} ]]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
        DISPLAY=":0.0"          # Display on local host.
    else
        DISPLAY=${XSERVER}:0.0     # Display on remote host.
    fi

    export DISPLAY
fi
