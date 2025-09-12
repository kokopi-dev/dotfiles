#!/bin/bash
IMAGE_DIR=~/.config/rofi/images/neco
THEME_FILE=~/.config/rofi/app-manager/app-manager.rasi
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

rofi -show drun -theme $THEME_FILE
