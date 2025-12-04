#!/bin/bash

THEME_FILE=~/.config/rofi/app-manager/app-manager.rasi

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

rofi -show drun -theme ~/.config/rofi/app-manager/app-manager.rasi
post_rofi &
