#!/bin/bash
grim -g "$(slurp)" - | satty --filename - --output-filename ~/pictures/$(date +"%Y-%m-%d_%H-%M-%S").png --early-exit --copy-command wl-copy
