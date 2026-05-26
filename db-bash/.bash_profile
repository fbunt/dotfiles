# ~/.bash_profile

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
. "$HOME/.cargo/env"

# eval $(keychain --eval --agents ssh <keys list>)
