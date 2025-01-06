#!/usr/bin/env bash

set -e

PROFILE_SCRIPT=/etc/profile.d/homebrew.sh

cat >"${PROFILE_SCRIPT}" <<'EOF'
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    # For non-linuxbrew users, provide a wrapper to run brew as linuxbrew user
    if [ "${USER}" != "linuxbrew" ]; then
        brew() {
            sudo --user linuxbrew --login brew "$@"
        }
    fi
fi
EOF

# Set appropriate permissions
chmod 644 "${PROFILE_SCRIPT}"

echo "Homebrew environment configuration has been installed to ${PROFILE_SCRIPT}"
echo "The changes will take effect on next login or shell restart."
