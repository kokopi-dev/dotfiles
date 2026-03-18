#!/bin/bash

MODE=${1:-area}
OUTPUT=~/pictures/$(date +"%Y-%m-%d_%H-%M-%S").png

case "$MODE" in
  area)
    grim -g "$(slurp)" - | satty --filename - --output-filename "$OUTPUT" --early-exit --copy-command wl-copy
    ;;
  screen)
    grim -g "$(slurp -o)" - | satty --filename - --output-filename "$OUTPUT" --early-exit --copy-command wl-copy
    ;;
  *)
    echo "Usage: $0 [area|screen]"
    exit 1
    ;;
esac
