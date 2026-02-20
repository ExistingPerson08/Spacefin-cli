#!/bin/bash
# name: Cleanup system
podman image prune -af
podman volume prune -f
sudo podman image prune -af
sudo podman volume prune -f
flatpak uninstall --unused
brew autoremove
brew cleanup
