#!/bin/bash
if pgrep -x wl-screenrec > /dev/null; then pkill -INT wl-screenrec && notify-send "🎥 Recording Stopped" "Saved to ~/videos"; else GEOMETRY=$(slurp); if [ -n "$GEOMETRY" ]; then notify-send "🎥 Recording Started" "Press Super+Alt+v to stop" && wl-screenrec -g "$GEOMETRY" -f ~/videos/recording-$(date +"%Y-%m-%d_%H-%M-%S").mp4 & fi; fi
