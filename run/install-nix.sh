#!/bin/bash
# name: Install Nix

set -euo pipefail

NIX_DAEMON_SCRIPT="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
NIX_INSTALLER="https://install.determinate.systems/nix"

echo "Setting up Nix package manager..."
curl --proto '=https' --tlsv1.2 -sSf -L "$NIX_INSTALLER" | sh -s -- install --no-confirm
[ -f "$NIX_DAEMON_SCRIPT" ] && . "$NIX_DAEMON_SCRIPT"
echo "Nix package manager installed."
