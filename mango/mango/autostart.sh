#!/bin/bash
set +e

swww-daemon & disown
while ! swww query &>/dev/null; do
    sleep 0.1
done
swww clear 000000
sleep 0.1
swww img ~/pictures/flower.jpg --transition-type fade --transition-duration 1 &

export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}
export XDG_CURRENT_DESKTOP=wlroots

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
/usr/lib/xdg-desktop-portal &

export DISPLAY=:0

wl-clip-persist --clipboard regular --reconnect-tries 0 &
wl-paste --type text --watch cliphist store &

gsettings set org.gnome.desktop.interface gtk-theme 'tokyonight-dark'
gsettings set org.gnome.desktop.interface icon-theme 'catppuccin-mocha'
gsettings set org.gnome.desktop.interface font-name 'Geist 11'

fcitx5 -d

kanshi &
