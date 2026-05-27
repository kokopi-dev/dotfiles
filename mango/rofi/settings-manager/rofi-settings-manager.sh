#!/bin/bash
# run init setup.sh to symlink scripts
THEME_FILE=~/.config/rofi/settings-manager/settings-manager.rasi

post_rofi() {
    local image_dir="$HOME/.config/rofi/images/sg"
    local current_image=$(grep "background-image: url" "$THEME_FILE" | cut -d'"' -f2)
    local new_image=$(find "$image_dir" -type f | sort -R | head -n 1 | sed "s|^$HOME|~|")
    while true; do
        if [[ "$new_image" != "$current_image" ]]; then
            sed -i 's|url("[^"]*"|url("'"$new_image"'"|' "$THEME_FILE"
            break
        fi
        new_image=$(find "$image_dir" -type f | sort -R | head -n 1 | sed "s|^$HOME|~|")
    done
}

SETTINGS="   Settings"
MONITOR="󰍹   Displays"
WALLPAPER="   Wallpaper"
SOUND="   Sound"
BLUETOOTH="󰂯   Bluetooth"
NETWORK="󰲝   Network"
STORAGE="   Disk Usage"
# NIGHTLIGHT="   Night Light"

chosen=$(echo -e "$SETTINGS\n$MONITOR\n$NETWORK\n$SOUND\n$BLUETOOTH\n$WALLPAPER\n$STORAGE" | rofi -mesg " Settings" -dmenu -p "Action:" -config ~/.config/rofi/settings-manager/settings-manager.rasi -monitor "$ROFI_MONITOR")

# `dms ipc call settings tabs` to get the list of tabs
case $chosen in
    "$SETTINGS")
        dms ipc call settings open
        ;;
    "$MONITOR")
        # has nightlight options on the side
        dms ipc call settings openWith displays
        # wdisplays
        ;;
    "$NETWORK")
        dms ipc call settings openWith network
        # ghostty -e nmtui
        ;;
    "$WALLPAPER")
        dms ipc call settings openWith wallpaper
        # waypaper
        ;;
    "$SOUND")
        # dms ipc call settings openWith audio
        pavucontrol
        ;;
    "$BLUETOOTH")
        # dms ipc call control-center openWith bluetooth
        blueman-manager
        ;;
    "$STORAGE")
        ghostty -e gdu
        ;;
    # "$NIGHTLIGHT")
    #     ghostty -e ~/.local/bin/run-wlsunset.sh
    #     ;;
esac

if [[ "$HOSTNAME" == "astra" ]]; then
    post_rofi &
fi
