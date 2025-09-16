#!/bin/bash
# save as ~/.local/bin/rofi-power-manager.sh

LOCKSCREEN="   Lock Screen"
REBOOT="   Reboot"
SHUTDOWN="   Shutdown"
chosen=$(echo -e "$LOCKSCREEN\n$REBOOT\n$SHUTDOWN" | rofi -mesg "󰚥 $HOSTNAME" -dmenu -p "Action:" -config ~/.config/rofi/power-manager/power-manager.rasi)

case $chosen in
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
