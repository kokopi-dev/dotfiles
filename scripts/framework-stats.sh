#!/bin/bash

BAT_CYCLE=$(cat /sys/class/power_supply/BAT1/cycle_count)
echo -e "Note: 80% retained after 1000 cycles\n  Current Cycles: $BAT_CYCLE cycles"
