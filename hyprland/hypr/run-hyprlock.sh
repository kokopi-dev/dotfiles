#!/bin/bash
post_unlock() {
    local image_dir="$HOME/pictures/bgs/lockscreen"
    local current_image=$(grep "path =" ~/.config/hypr/hyprlock.conf | cut -d'=' -f2 | tr -d ' ' | head -1)
    local new_image=$(find "$image_dir" -type f | sort -R | head -n 1 | sed "s|^$HOME|~|")
    while true; do
        if [[ "$new_image" != "$current_image" ]]; then
            sed -i '0,/path =/{s|path =.*|path = '"$new_image"'|}' ~/.config/hypr/hyprlock.conf
            break
        fi
        new_image=$(find "$image_dir" -type f | sort -R | head -n 1 | sed "s|^$HOME|~|")
    done
}

post_unlock
hyprlock
