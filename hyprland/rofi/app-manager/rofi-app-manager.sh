#!/bin/bash

get_current_monitor_width() {
    # Get cursor position from Hyprland
    local pos=$(hyprctl cursorpos 2>/dev/null | head -n 1)
    
    if [ -z "$pos" ]; then
        echo "Error: Could not get cursor position from Hyprland" >&2
        return 1
    fi
    
    # Extract coordinates (hyprctl cursorpos returns: "x, y")
    local x=$(echo "$pos" | awk -F',' '{print $1}' | tr -d ' ')
    local y=$(echo "$pos" | awk -F',' '{print $2}' | tr -d ' ')
    
    # Get the width of the monitor containing the cursor
    local width=$(hyprctl monitors -j | jq -r --argjson x "$x" --argjson y "$y" '
        .[] | select(
            .x <= $x and 
            .y <= $y and 
            (.x + .width) > $x and 
            (.y + .height) > $y
        ) | .width' | head -n 1)
    
    echo "$width"
}

post_rofi() {
    local image_dir="$HOME/.config/rofi/images/neco"
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
