#!/bin/bash
IMAGE_DIR=~/pictures/rofi-sqrs
THEME_FILE=~/.config/rofi/config.rasi
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

sed -i "s|background-image: url(\".*\", height);|background-image: url(\"$IMAGE\", height);|" $THEME_FILE

rofi -show drun -theme $THEME_FILE
