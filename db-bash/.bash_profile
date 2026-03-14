# ~/.bash_profile

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
. "$HOME/.cargo/env"

eval `keychain -q --eval --agents ssh id_ed25519`
eval `keychain -q --eval --agents ssh lab_pc`

. "$HOME/.local/share/../bin/env"
