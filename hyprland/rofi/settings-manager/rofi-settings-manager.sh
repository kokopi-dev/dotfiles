#!/bin/bash
# save as ~/.local/bin/rofi-power-manager.sh

IMAGE_DIR=~/.config/rofi/images/sg
THEME_FILE=~/.config/rofi/settings-manager/settings-manager.rasi
LOG_FILE=~/.config/rofi/.randomized_image.log

IMAGE=$(find "$IMAGE_DIR" -type f | sort -R | head -n 1)
LAST_IMAGE=$(cat ~/.config/rofi/.randomized_image.log)

while true; do
    if [[ "$IMAGE" != "$LAST_IMAGE" ]]; then
        echo "$IMAGE" > $LOG_FILE
        break
    fi
    IMAGE=$(find "$IMAGE_DIR" -type f | sort -R | head -n 1)
done

sed -i "s|background-image: url(\".*\", width);|background-image: url(\"$IMAGE\", width);|" $THEME_FILE

MONITOR="󰍹   Monitor"
SOUND="   Sound"
BLUETOOTH="󰂯   Bluetooth"
NETWORK="󰲝   Network"
chosen=$(echo -e "$MONITOR\n$SOUND\n$BLUETOOTH\n$NETWORK" | rofi -dmenu -p "Action:" -config ~/.config/rofi/settings-manager/settings-manager.rasi)

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
esac
