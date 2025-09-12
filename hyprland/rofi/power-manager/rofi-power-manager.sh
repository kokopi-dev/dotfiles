#!/bin/bash
# save as ~/.local/bin/rofi-power-manager.sh

LOCKSCREEN="   Lock Screen"
REBOOT="   Reboot"
SHUTDOWN="   Shutdown"
TEST=" Test"
chosen=$(echo -e "$LOCKSCREEN\n$REBOOT\n$SHUTDOWN\n$TEST" | rofi -dmenu -p "Action:" -config ~/.config/rofi/power-manager/power-manager.rasi)

case $chosen in
    "$LOCKSCREEN")
        pid hyprlock || hyprlock
        ;;
    "$REBOOT")
        systemctl reboot
        ;;
    "$SHUTDOWN")
        systemctl poweroff
        ;;
    "$TEST")
        notify-send "test" "test"
        ;;
esac
