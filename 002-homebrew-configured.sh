#!/usr/bin/env bash

set -e

HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
HOMEBREW_SHELLENV_COMMAND='eval "$('${HOMEBREW_PREFIX}'/bin/brew shellenv)"'

add_homebrew_shellenv() {
    local file="$1"
    if ! grep -q "Setup Homebrew if it exists" "$file"; then
        echo "
# Setup Homebrew if it exists
if [ -d \"$HOMEBREW_PREFIX\" ]; then
  export PATH=\"/usr/local/bin:\$PATH\"
  $HOMEBREW_SHELLENV_COMMAND
else
  echo \"Homebrew is not installed in the expected location.\" >&2
fi" >>"$file"
    fi
}

add_root_brew_wrapper() {
    local file="$1"
    if [ "$EUID" -eq 0 ] && ! grep -q "Function to run brew as linuxbrew user" "$file"; then
        echo '
# Function to run brew as linuxbrew user
brew() {
   sudo --user linuxbrew --login brew "$@"
}
' >>"$file"
    fi
}

add_homebrew_shellenv ~/.bashrc
add_homebrew_shellenv ~/.profile
add_homebrew_shellenv "/etc/skel/.profile"
add_homebrew_shellenv "/etc/skel/.bashrc"
add_homebrew_shellenv "/root/.profile"
add_homebrew_shellenv "/root/.bashrc"
add_homebrew_shellenv "/home/linuxbrew/.bashrc"
add_homebrew_shellenv "/home/linuxbrew/.profile"

add_root_brew_wrapper "/root/.bashrc"
add_root_brew_wrapper "/root/.profile"

echo "Homebrew environment configuration completed successfully."
