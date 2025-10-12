#!/bin/bash
# run init setup.sh to symlink scripts
THEME_FILE=~/.config/rofi/settings-manager/settings-manager.rasi
get_current_monitor() {
    # Use Hyprland's native cursor position
    local pos=$(hyprctl cursorpos 2>/dev/null)
    
    if [ -z "$pos" ]; then
        echo "Error: Could not get cursor position from Hyprland" >&2
        return 1
    fi
    
    # Strip whitespace and extract coordinates
    local x=$(echo "$pos" | cut -d',' -f1 | tr -d ' ')
    local y=$(echo "$pos" | cut -d',' -f2 | tr -d ' ')
    
    hyprctl monitors -j | jq -r --arg x "$x" --arg y "$y" '
        .[] | select(
            .x <= ($x | tonumber) and 
            .y <= ($y | tonumber) and 
            (.x + .width) >= ($x | tonumber) and 
            (.y + .height) >= ($y | tonumber)
        ) | .name'
}

# Store the monitor at the start
if [ -z "$ROFI_MONITOR" ]; then
    export ROFI_MONITOR=$(get_current_monitor)
fi

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


MONITOR_RELOAD="󰑓  Refresh"
MONITOR_SETTINGS="󰍹   Settings"
MONITOR_BACK="   Back"
MONITOR="   Monitor"
SOUND="   Sound"
BLUETOOTH="󰂯   Bluetooth"
NETWORK="󰲝   Network"
NIGHTLIGHT="   Night Light"

if [[ "$1" == "monitor" ]]; then
    chosen=$(echo -e "$MONITOR_RELOAD\n$MONITOR_SETTINGS\n$MONITOR_BACK" | rofi -mesg "󰍹  Monitor" -dmenu -p "Action:" -config ~/.config/rofi/settings-manager/settings-manager.rasi -monitor "$ROFI_MONITOR")
else
    chosen=$(echo -e "$MONITOR\n$SOUND\n$BLUETOOTH\n$NETWORK\n$NIGHTLIGHT" | rofi -mesg " Settings" -dmenu -p "Action:" -config ~/.config/rofi/settings-manager/settings-manager.rasi -monitor "$ROFI_MONITOR")
fi

case $chosen in
    "$MONITOR_BACK")
        bash ~/.config/rofi/settings-manager/rofi-settings-manager.sh
        ;;
    "$MONITOR")
        bash ~/.config/rofi/settings-manager/rofi-settings-manager.sh "monitor"
        ;;
    "$MONITOR_RELOAD")
        bash ~/.config/hypr/reload-monitors.sh
        ;;
    "$MONITOR_SETTINGS")
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
