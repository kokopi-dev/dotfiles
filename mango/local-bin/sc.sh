#!/bin/bash
if pgrep -x wl-screenrec > /dev/null; then pkill -INT wl-screenrec && notify-send "🎥 Recording Stopped" "Saved to ~/videos"; else GEOMETRY=$(slurp); if [ -n "$GEOMETRY" ]; then notify-send "🎥 Recording Started" "Press Super+Alt+v to stop" && wl-screenrec -g "$GEOMETRY" -f ~/videos/recording-$(date +"%Y-%m-%d_%H-%M-%S").mp4 & fi; fi
# silent portion record
# if pgrep -x wl-screenrec > /dev/null; then pkill -INT wl-screenrec && notify-send "🎥 Recording Stopped" "Saved to ~/videos"; else GEOMETRY=$(slurp); if [ -n "$GEOMETRY" ]; then wl-screenrec -g "$GEOMETRY" -f ~/videos/recording-$(date +"%Y-%m-%d_%H-%M-%S").mp4 & fi; fi
#
# main screen only for yt
# if pgrep -x wl-screenrec > /dev/null; then pkill -INT wl-screenrec && notify-send "🎥 Recording Stopped" "Saved to ~/videos"; else wl-screenrec -o DP-3 -f ~/videos/recording-$(date +"%Y-%m-%d_%H-%M-%S").mp4 & fi
