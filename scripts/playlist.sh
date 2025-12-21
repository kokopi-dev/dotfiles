#!/bin/bash
if ! command -v mpv &> /dev/null; then
    echo "mpv is not installed"
    exit 1
fi
echo "space = play/pause"
echo "<,> = back,next"
echo "q = quit"
echo "left/right = skip seconds"
mpv --shuffle --loop-playlist=inf "$@"
