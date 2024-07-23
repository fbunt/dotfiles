# Install or update starship
function update_starship() {
    curl -sS https://starship.rs/install.sh | sh
}

eval "$(starship init bash)"
