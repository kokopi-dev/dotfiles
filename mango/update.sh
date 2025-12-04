#!/bin/bash
cp -r ~/.config/mango/* ./mango
cp -r ~/.config/waybar/* ./waybar
cp -r ~/.config/kanshi/* ./kanshi
cp -r ~/.config/xdg-desktop-portal/* ./xdg-desktop-portal
cp ~/.config/user-dirs.conf .
cp ~/.config/starship.toml .
cp -r ~/.config/waypaper/* ./waypaper
cp -r ~/.config/fastfetch/* ./fastfetch
rsync -av ~/.config/fontconfig/ ./fontconfig
rsync -av ~/.config/btop/ ./btop

cp ~/.config/rofi/theme.rasi ./rofi
cp ~/.config/rofi/app-manager/* ./rofi/app-manager
cp ~/.config/rofi/settings-manager/* ./rofi/settings-manager
cp ~/.config/rofi/power-manager/* ./rofi/power-manager
cp ~/.config/rofi/config-manager/* ./rofi/config-manager
cp ~/.config/rofi/help-manager/* ./rofi/help-manager
cp ~/.config/rofi/setup.sh ./rofi
