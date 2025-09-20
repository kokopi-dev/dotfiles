#!/bin/bash
current_im=$(fcitx5-remote -n 2>/dev/null)
if [[ "$current_im" == "anthy" ]]; then
    CURRENT_STATUS="JP"
else
    CURRENT_STATUS="EN"
fi

dbus-monitor --session "type='signal',interface='org.fcitx.Fcitx.InputContext1',member='CurrentIM'" 2>/dev/null | \
while IFS= read -r line; do
    if [[ "$line" == *"member=CurrentIM"* ]]; then
        # Read the next line which contains the input method string
        read -r im_line
        if [[ "$im_line" == *"Anthy"* ]]; then
            NEW_STATUS="JP"
        else
            NEW_STATUS="EN"
        fi
        
        # Only refresh if status actually changed
        if [[ "$NEW_STATUS" != "$CURRENT_STATUS" ]]; then
            sleep 0.1
            pkill -RTMIN+8 waybar
            CURRENT_STATUS="$NEW_STATUS"
        fi
    fi
done
