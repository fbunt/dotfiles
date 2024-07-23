prepend_to_path "$HOME/.local/bin"
# Apple specific
if [[ $OS == Darwin ]]; then
    #Brew Clang
    prepend_to_path "/usr/local/opt/llvm/bin"

    # MacGhostView
    append_to_path "/Applications/MacGhostView.app/Contents/Resources/bin"

    # Add android tools to PATH
    prepend_to_path "$HOME/Library/Android/sdk/platform-tools"

    append_to_path "/opt/local/bin"
fi
prepend_to_path "$HOME/bin"
# Add snaps
append_to_path "/snap/bin"
