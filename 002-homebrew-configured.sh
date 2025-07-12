#!/usr/bin/env bash

set -e

sudo tee /etc/profile.d/homebrew.sh <<'EOF'
#!/usr/bin/env bash

[ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && return

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

[ "${USER:-}" = "linuxbrew" ] && return

brew() {
    sudo --user linuxbrew --login brew "$@"
}
EOF

sudo chmod +x /etc/profile.d/homebrew.sh
