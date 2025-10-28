#!/bin/bash
# save as ~/.local/bin/rofi-power-manager.sh

LOCKSCREEN="   Lock Screen"
SLEEP="󰤄   Sleep"
REBOOT="   Reboot"
SHUTDOWN="   Shutdown"
chosen=$(echo -e "$SLEEP\n$REBOOT\n$SHUTDOWN\n$LOCKSCREEN" | rofi -mesg "󰚥 $HOSTNAME" -dmenu -p "Action:" -config ~/.config/rofi/power-manager/power-manager.rasi)

case $chosen in
    "$SLEEP")
        systemctl suspend-then-hibernate
        ;;
    "$LOCKSCREEN")
        pid hyprlock || ~/.config/hypr/run-hyprlock.sh
        ;;
    "$REBOOT")
        systemctl reboot
        ;;
    "$SHUTDOWN")
        systemctl poweroff
        ;;
esac
