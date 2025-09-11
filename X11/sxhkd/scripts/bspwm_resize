#!/bin/bash
#++ requirements:
#+ sudo pacman -S xdo
size=${2:-'10'}
dir=$1

is_tiled() {
  bspc query -T -n | grep -q '"state":"tiled"'
}
if ! is_tiled; then
  case "$dir" in
    west) switch="-w"
    sign="-"
    ;;
    east) switch="-w"
    sign="+"
    ;;
    north) switch="-h"
    sign="-"
    ;;
    south) switch="-h"
    sign="+"
    ;;
  esac
  xdo resize ${switch} ${sign}${size}
else
  case "$dir" in
    west) bspc node @west -r -$size || bspc node @east -r -${size}
    ;;
    east) bspc node @west -r +$size || bspc node @east -r +${size}
    ;;
    north) bspc node @south -r -$size || bspc node @north -r -${size}
    ;;
    south) bspc node @south -r +$size || bspc node @north -r +${size}
    ;;
  esac
fi
