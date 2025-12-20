#!/bin/bash
# name: Cleanup system
podman image prune -af
podman volume prune -f
flatpak uninstall --unused
rpm-ostree cleanup -bm
brew autoremove
brew cleanup
