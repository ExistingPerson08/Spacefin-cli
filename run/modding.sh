#!/bin/bash
# name: Setup Modding

echo ""
echo "Installing r2modman"
echo ""

TEMP_FILE="/tmp/r2modman.flatpak"

curl -L "https://github.com/ebkr/r2modmanPlus/releases/download/v3.2.15/r2modman-3.2.15-x86_64.flatpak" -o "$TEMP_FILE"
flatpak install -y --system "$TEMP_FILE"
rm "$TEMP_FILE"

echo ""
echo "Installing Curseforge app"
echo ""

TEMP_FILE="/tmp/curseforge.AppImage"

flatpak install -y --system flathub it.mijorus.gearlever
curl -L "ttps://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage" -o "$TEMP_FILE"
flatpak run it.mijorus.gearlever --integrate "$TEMP_FILE" -y --replace

echo ""
echo "Installing Proton tools"
echo ""

flatpak install -y --system flathub net.davidotek.pupgui2
flatpak install -y --system flathub com.github.Matoking.protontricks

echo ""
echo "Modding setup finished!"
