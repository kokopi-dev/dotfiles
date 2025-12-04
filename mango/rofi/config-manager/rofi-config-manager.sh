#!/bin/bash
# ln -s ~/.config/rofi/config-manager/rofi-config-manager.sh ~/.local/bin/rofi-config-manager.sh
THEME_FILE=~/.config/rofi/config-manager/config-manager.rasi

NVIM="   Neovim"
HYPRLAND="   Hyprland"
WAYBAR="   Waybar"
GHOSTTY="   Ghostty"
ROFI_APP="   Rofi App"
ROFI_SETT="   Rofi Sett"
ROFI_CONF="   Rofi Conf"
ROFI_POW="   Rofi Pow"
HYPRLOCK="   Hyprlock"
HYPRIDLE="󰒲   Hypridle"
HYPRPAPER="   Hyprpaper"
MAKO="   Mako"
chosen=$(echo -e "$NVIM\n$HYPRLAND\n$WAYBAR\n$GHOSTTY\n$ROFI_APP\n$ROFI_SETT\n$ROFI_CONF\n$ROFI_POW\n$HYPRLOCK\n$HYPRIDLE\n$MAKO\n$HYPRPAPER" | rofi -mesg " Configs" -dmenu -p "Action:" -config ~/.config/rofi/config-manager/config-manager.rasi)

case $chosen in
    "$NVIM")
        ghostty -e nvim ~/.config/nvim/init.lua & disown
        ghostty -e nvim ~/.config/nvim/lua/settings.lua & disown
        ;;
    "$HYPRLAND")
        ghostty -e nvim ~/.config/hypr/hyprland.conf & disown
        ;;
    "$HYPRLOCK")
        ghostty -e nvim ~/.config/hypr/hyprlock.conf & disown
        ;;
    "$HYPRIDLE")
        ghostty -e nvim ~/.config/hypr/hypridle.conf & disown
        ;;
    "$WAYBAR")
        ghostty -e nvim ~/.config/waybar/config.jsonc & disown
        ghostty -e nvim ~/.config/waybar/style.css & disown
        ;;
    "$GHOSTTY")
        ghostty -e nvim ~/.config/ghostty/config & disown
        ghostty -e nvim ~/.config/ghostty/themes/navarch & disown
        ;;
    "$MAKO")
        ghostty -e nvim ~/.config/mako/config & disown
        ;;
    "$ROFI_APP")
        ghostty -e nvim ~/.config/rofi/app-manager/app-manager.rasi & disown
        ghostty -e nvim ~/.config/rofi/app-manager/rofi-app-manager.sh & disown
        ;;
    "$ROFI_SETT")
        ghostty -e nvim ~/.config/rofi/settings-manager/settings-manager.rasi & disown
        ghostty -e nvim ~/.config/rofi/settings-manager/rofi-settings-manager.sh & disown
        ;;
    "$ROFI_CONF")
        ghostty -e nvim ~/.config/rofi/config-manager/config-manager.rasi & disown
        ghostty -e nvim ~/.config/rofi/config-manager/rofi-config-manager.sh & disown
        ;;
    "$ROFI_POW")
        ghostty -e nvim ~/.config/rofi/power-manager/power-manager.rasi & disown
        ghostty -e nvim ~/.config/rofi/power-manager/rofi-power-manager.sh & disown
        ;;
    "$HYPRPAPER")
        ghostty -e nvim ~/.config/hypr/hyprpaper.conf & disown
        ;;
esac
