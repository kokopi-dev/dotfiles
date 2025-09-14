#!/bin/bash
# run init setup.sh to symlink scripts
THEME_FILE=~/.config/rofi/settings-manager/settings-manager.rasi

post_rofi() {
    local image_dir="$HOME/.config/rofi/images/sg"
    local current_image=$(grep "background-image: url" file | cut -d'"' -f2)
    local new_image=$(find "$image_dir" -type f | sort -R | head -n 1 | sed "s|^$HOME|~|")
    while true; do
        if [[ "$new_image" != "$current_image" ]]; then
            sed -i 's|url("[^"]*"|url("'"$new_image"'"|' "$THEME_FILE"
            break
        fi
        new_image=$(find "$image_dir" -type f | sort -R | head -n 1 | sed "s|^$HOME|~|")
    done
}

MONITOR="󰍹   Monitor"
SOUND="   Sound"
BLUETOOTH="󰂯   Bluetooth"
NETWORK="󰲝   Network"
NIGHTLIGHT="   Night Light"
chosen=$(echo -e "$MONITOR\n$SOUND\n$BLUETOOTH\n$NETWORK\n$NIGHTLIGHT" | rofi -dmenu -p "Action:" -config ~/.config/rofi/settings-manager/settings-manager.rasi)

case $chosen in
    "$MONITOR")
        ghostty -e hyprmon
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
        ghostty -e ~/.config/wlsunset/run-wlsunset.sh
        ;;
esac

post_rofi &
