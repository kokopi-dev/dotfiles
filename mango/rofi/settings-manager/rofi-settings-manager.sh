#!/bin/bash
# run init setup.sh to symlink scripts
THEME_FILE=~/.config/rofi/settings-manager/settings-manager.rasi

MONITOR="󰍹   Monitor"
WALLPAPER="   Wallpaper"
SOUND="   Sound"
BLUETOOTH="󰂯   Bluetooth"
NETWORK="󰲝   Network"
NIGHTLIGHT="   Night Light"

chosen=$(echo -e "$MONITOR\n$SOUND\n$BLUETOOTH\n$NETWORK\n$NIGHTLIGHT" | rofi -mesg " Settings" -dmenu -p "Action:" -config ~/.config/rofi/settings-manager/settings-manager.rasi -monitor "$ROFI_MONITOR")

case $chosen in
    "$MONITOR")
        wdisplays
        ;;
    "$WALLPAPER")
        waypaper
        ;;
    "$SOUND")
        pavucontrol
        ;;
    "$BLUETOOTH")
        blueman-manager
        ;;
    "$NETWORK")
        ghostty -e nmtui
        ;;
    "$NIGHTLIGHT")
        ghostty -e ~/.local/bin/run-wlsunset.sh
        ;;
esac

post_rofi &
