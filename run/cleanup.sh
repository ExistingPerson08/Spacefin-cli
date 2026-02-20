#!/bin/bash
# name: Cleanup system
sudo podman image prune -af
sudo podman volume prune -f
podman image prune -af
podman volume prune -f
flatpak uninstall --unused
brew autoremove
brew cleanup
