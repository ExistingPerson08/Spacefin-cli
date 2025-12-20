#!/bin/bash
# name: Reset niri config

rm -r ~/.config/niri/
rm ~/.config/ghostty/config

cp -r /etc/skel/.config/niri/ ~/.config/
cp /etc/skel/.config/ghostty/config ~/.config/ghostty/
