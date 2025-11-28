#!/bin/bash

cp ~/.config/rofi/theme.rasi ./rofi
cp ~/.config/rofi/app-manager/* ./rofi/app-manager
cp ~/.config/rofi/settings-manager/* ./rofi/settings-manager
cp ~/.config/rofi/config-manager/* ./rofi/config-manager
cp ~/.config/rofi/power-manager/* ./rofi/power-manager
cp ~/.config/rofi/help-manager/* ./rofi/help-manager
cp ~/.config/rofi/setup.sh ./rofi

cp ~/.config/wlsunset/run-wlsunset.sh ./wlsunset

cp ~/.config/hypr/* ./hypr

cp ~/.config/fastfetch/* ./fastfetch

cp -r ~/.config/waybar/* ./waybar

cp ~/.config/mako/* ./mako

cp -r ~/.config/ghostty/* ./ghostty

cp -r ~/.config/btop/* ./btop

cp -r ~/.config/gtk-3.0/* ./gtk-3.0

cp -r ~/.config/gtk-4.0/* ./gtk-4.0

cp ~/.config/starship.toml .
