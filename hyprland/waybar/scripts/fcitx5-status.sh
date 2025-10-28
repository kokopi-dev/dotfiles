#!/bin/bash
# Get current fcitx5 input method
IM=$(fcitx5-remote -n 2>/dev/null)

# Check if fcitx5 is running
if [ -z "$IM" ]; then
    echo "EN"
    exit 0
fi

case "$IM" in
    "keyboard-us")
        echo "EN"
        ;;
    "anthy")
        echo "JP"
        ;;
    "mozc-jp")
        echo "JP"
        ;;
    *)
        # Fallback - show first 2 characters of input method name
        echo "${IM:0:2}" | tr '[:lower:]' '[:upper:]'
        ;;
esac
