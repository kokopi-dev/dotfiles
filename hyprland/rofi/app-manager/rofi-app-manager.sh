#!/bin/bash

get_current_monitor_width() {
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
        ) | .width'
}

post_rofi() {
    local image_dir="$HOME/.config/rofi/images/neco"
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

width=$(get_current_monitor_width)
if [ "$width" -gt 2256 ]; then
    #is wider than laptop monitor
    THEME_FILE=~/.config/rofi/app-manager/app-manager-wide.rasi
else
    #laptop monitor
    THEME_FILE=~/.config/rofi/app-manager/app-manager.rasi
fi
rofi -show drun -theme $THEME_FILE
post_rofi &
