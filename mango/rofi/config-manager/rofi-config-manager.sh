#!/bin/bash
# ln -s ~/.config/rofi/config-manager/rofi-config-manager.sh ~/.local/bin/rofi-config-manager.sh
THEME_FILE=~/.config/rofi/config-manager/config-manager.rasi

MANGO="   Mango"
BACK="   Back"
MANGO_CONF="   Config"
MANGO_START="   Autostart"
MANGO_BIND="   Binds"
MANGO_RULES="󰇙   Rules"
MANGO_ENV="   Env"
MANGO_EXEC="   Exec"
NVIM="   Neovim"
WAYBAR="   Waybar"
GHOSTTY="   Ghostty"
ROFI="   Rofi"
ROFI_APP="   App"
ROFI_SETT="   Setting"
ROFI_CONF="   Config"
ROFI_POW="   Power"
MAKO="   Mako"

if [[ "$1" == "mango" ]]; then
    chosen=$(echo -e "$MANGO_CONF\n$MANGO_START\n$MANGO_BIND\n$MANGO_RULES\n$MANGO_ENV\n$MANGO_EXEC\n$BACK" | rofi -mesg "󰨇 Mango" -dmenu -p "Action:" -config ~/.config/rofi/config-manager/config-manager.rasi)
elif [[ "$1" == "rofi" ]]; then
    chosen=$(echo -e "$ROFI_APP\n$ROFI_SETT\n$ROFI_CONF\n$ROFI_POW\n$BACK" | rofi -mesg " Rofi" -dmenu -p "Action:" -config ~/.config/rofi/config-manager/config-manager.rasi)
else
    chosen=$(echo -e "$MANGO\n$NVIM\n$WAYBAR\n$GHOSTTY\n$ROFI\n$MAKO" | rofi -mesg " Configs" -dmenu -p "Action:" -config ~/.config/rofi/config-manager/config-manager.rasi)
fi

case $chosen in
    "$BACK")
        bash ~/.config/rofi/config-manager/rofi-config-manager.sh
        ;;
    "$ROFI")
        bash ~/.config/rofi/config-manager/rofi-config-manager.sh "rofi"
        ;;
    "$MANGO")
        bash ~/.config/rofi/config-manager/rofi-config-manager.sh "mango"
        ;;
    "$MANGO_CONF")
        ghostty -e nvim ~/.config/mango/config.conf & disown
        ;;
    "$MANGO_START")
        ghostty -e nvim ~/.config/mango/autostart.sh & disown
        ;;
    "$MANGO_BIND")
        ghostty -e nvim ~/.config/mango/keybindings.conf & disown
        ;;
    "$MANGO_RULES")
        ghostty -e nvim ~/.config/mango/rules.conf & disown
        ;;
    "$MANGO_ENV")
        ghostty -e nvim ~/.config/mango/env.conf & disown
        ;;
    "$MANGO_EXEC")
        ghostty -e nvim ~/.config/mango/exec.conf & disown
        ;;
    "$NVIM")
        ghostty -e nvim ~/.config/nvim/init.lua & disown
        ghostty -e nvim ~/.config/nvim/lua/settings.lua & disown
        ;;
    "$WAYBAR")
        ghostty -e nvim ~/.config/waybar/config.jsonc & disown
        ghostty -e nvim ~/.config/waybar/style.css & disown
        ;;
    "$GHOSTTY")
        ghostty -e nvim ~/.config/ghostty/config & disown
        ghostty -e nvim ~/.config/ghostty/themes/navarch & disown
        ;;
    "$MAKO")
        ghostty -e nvim ~/.config/mako/config & disown
        ;;
    "$ROFI_APP")
        ghostty -e nvim ~/.config/rofi/app-manager/app-manager.rasi & disown
        ghostty -e nvim ~/.config/rofi/app-manager/rofi-app-manager.sh & disown
        ;;
    "$ROFI_SETT")
        ghostty -e nvim ~/.config/rofi/settings-manager/settings-manager.rasi & disown
        ghostty -e nvim ~/.config/rofi/settings-manager/rofi-settings-manager.sh & disown
        ;;
    "$ROFI_CONF")
        ghostty -e nvim ~/.config/rofi/config-manager/config-manager.rasi & disown
        ghostty -e nvim ~/.config/rofi/config-manager/rofi-config-manager.sh & disown
        ;;
    "$ROFI_POW")
        ghostty -e nvim ~/.config/rofi/power-manager/power-manager.rasi & disown
        ghostty -e nvim ~/.config/rofi/power-manager/rofi-power-manager.sh & disown
        ;;
esac
