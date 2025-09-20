#!/bin/bash
move_all_windows_to_workspace1() {
    # Get window count for feedback
    window_count=$(hyprctl clients -j | jq '. | length')
    # echo "Found $window_count windows to move"
    
    # Move all windows using xargs
    hyprctl clients -j | jq -r '.[].address' | xargs -I {} hyprctl dispatch movetoworkspacesilent "1,address:{}"
    
    # Switch to workspace 1 to make it active
    hyprctl dispatch workspace 1
}
home_dock=$(hyprctl monitors | grep -E "(DP-3|eDP-1)" | wc -l)

workspace_file="/tmp/hyprland-workspaces.conf"

echo "" > $workspace_file

if [[ $home_dock == 2 ]]; then
    move_all_windows_to_workspace1
    echo "workspace = 1,monitor:DP-3,default:true,persistent:true" >> $workspace_file
    echo "workspace = 2,monitor:DP-3,persistent:true" >> $workspace_file
    echo "workspace = 3,monitor:DP-3,persistent:true" >> $workspace_file
    echo "workspace = 4,monitor:DP-3,persistent:true" >> $workspace_file
    echo "workspace = 5,monitor:DP-3,persistent:true" >> $workspace_file

    echo "workspace = 6,monitor:eDP-1,default:true,persistent:true" >> $workspace_file
    echo "workspace = 7,monitor:eDP-1,persistent:true" >> $workspace_file
    echo "workspace = 8,monitor:eDP-1,persistent:true" >> $workspace_file
    echo "workspace = 9,monitor:eDP-1,persistent:true" >> $workspace_file
    echo "workspace = 10,monitor:eDP-1,persistent:true" >> $workspace_file
    notify-send "Monitor Reload" "Detected Home Dock Settings"
else
    move_all_windows_to_workspace1
    # default
    for i in {1..8}; do
        echo "workspace = $i,monitor:auto,persistent:true" >> $workspace_file
    done
    notify-send "Monitor Reload" "Detected Default Settings"
fi

hyprctl reload

if pidof waybar >/dev/null; then
    killall waybar && waybar & disown
else
    waybar & disown
fi
