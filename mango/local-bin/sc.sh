#!/bin/bash

MODE=${1:-area}
OUTPUT=~/videos/recording-$(date +"%Y-%m-%d_%H-%M-%S").mp4

if pgrep -x wl-screenrec >/dev/null; then
  pkill -INT wl-screenrec
  notify-send "🎥 Recording Stopped" "Saved to ~/videos"
  exit 0
fi

case "$MODE" in
  area)
    GEOMETRY=$(slurp)
    if [ -n "$GEOMETRY" ]; then
      notify-send "🎥 Recording Started (Area)" "Press Super+Alt+v to stop"
      wl-screenrec -g "$GEOMETRY" -f "$OUTPUT" &
    fi
    ;;
  screen)
    GEOMETRY=$(slurp -o)
    if [ -n "$GEOMETRY" ]; then
      notify-send "🎥 Recording Started (Screen)" "Press Super+Alt+v to stop"
      wl-screenrec -g "$GEOMETRY" -f "$OUTPUT" &
    fi
    ;;
  *)
    echo "Usage: $0 [area|screen]"
    exit 1
    ;;
esac
