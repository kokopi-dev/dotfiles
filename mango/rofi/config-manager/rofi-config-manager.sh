#!/bin/bash
# ln -s ~/.config/rofi/config-manager/rofi-config-manager.sh ~/.local/bin/rofi-config-manager.sh
THEME_FILE=~/.config/rofi/config-manager/config-manager.rasi

open_in_ghostty_nvim() {
    local file="$1"
    local dir
    dir=$(dirname "$file")
    ghostty -e bash -lc "cd $(printf '%q' "$dir") && exec nvim $(printf '%q' "$file")" & disown
}

post_rofi() {
    local image_dir="$HOME/.config/rofi/images/sg"
    local current_image=$(grep "background-image: url" "$THEME_FILE" | cut -d'"' -f2)
    local new_image=$(find "$image_dir" -type f | sort -R | head -n 1 | sed "s|^$HOME|~|")
    while true; do
        if [[ "$new_image" != "$current_image" ]]; then
            sed -i 's|url("[^"]*"|url("'"$new_image"'"|' "$THEME_FILE"
            break
        fi
        new_image=$(find "$image_dir" -type f | sort -R | head -n 1 | sed "s|^$HOME|~|")
    done
}

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
ROFI_HELP="   Help"
MAKO="   Mako"
KANSHI="󰍺   Kanshi"

if [[ "$1" == "mango" ]]; then
    chosen=$(echo -e "$MANGO_CONF\n$MANGO_START\n$MANGO_BIND\n$MANGO_RULES\n$MANGO_ENV\n$MANGO_EXEC\n$BACK" | rofi -mesg "󰨇 Mango" -dmenu -p "Action:" -config ~/.config/rofi/config-manager/config-manager.rasi)
elif [[ "$1" == "rofi" ]]; then
    chosen=$(echo -e "$ROFI_APP\n$ROFI_SETT\n$ROFI_CONF\n$ROFI_POW\n$ROFI_HELP\n$BACK" | rofi -mesg " Rofi" -dmenu -p "Action:" -config ~/.config/rofi/config-manager/config-manager.rasi)
else
    chosen=$(echo -e "$MANGO\n$NVIM\n$WAYBAR\n$GHOSTTY\n$ROFI\n$KANSHI\n$MAKO" | rofi -mesg " Configs" -dmenu -p "Action:" -config ~/.config/rofi/config-manager/config-manager.rasi)
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
        open_in_ghostty_nvim ~/.config/mango/config.conf
        ;;
    "$MANGO_START")
        open_in_ghostty_nvim ~/.config/mango/autostart.sh
        ;;
    "$MANGO_BIND")
        open_in_ghostty_nvim ~/.config/mango/keybindings.conf
        ;;
    "$MANGO_RULES")
        open_in_ghostty_nvim ~/.config/mango/rules.conf
        ;;
    "$MANGO_ENV")
        open_in_ghostty_nvim ~/.config/mango/env.conf
        ;;
    "$MANGO_EXEC")
        open_in_ghostty_nvim ~/.config/mango/exec.conf
        ;;
    "$NVIM")
        open_in_ghostty_nvim ~/.config/nvim/init.lua
        ;;
    "$WAYBAR")
        open_in_ghostty_nvim ~/.config/waybar/config.jsonc
        open_in_ghostty_nvim ~/.config/waybar/style.css
        ;;
    "$GHOSTTY")
        open_in_ghostty_nvim ~/.config/ghostty/config
        open_in_ghostty_nvim ~/.config/ghostty/themes/navarch
        ;;
    "$MAKO")
        open_in_ghostty_nvim ~/.config/mako/config
        ;;
    "$ROFI_APP")
        open_in_ghostty_nvim ~/.config/rofi/app-manager/app-manager.rasi
        open_in_ghostty_nvim ~/.config/rofi/app-manager/rofi-app-manager.sh
        ;;
    "$ROFI_SETT")
        open_in_ghostty_nvim ~/.config/rofi/settings-manager/settings-manager.rasi
        open_in_ghostty_nvim ~/.config/rofi/settings-manager/rofi-settings-manager.sh
        ;;
    "$ROFI_CONF")
        open_in_ghostty_nvim ~/.config/rofi/config-manager/config-manager.rasi
        open_in_ghostty_nvim ~/.config/rofi/config-manager/rofi-config-manager.sh
        ;;
    "$ROFI_POW")
        open_in_ghostty_nvim ~/.config/rofi/power-manager/power-manager.rasi
        open_in_ghostty_nvim ~/.config/rofi/power-manager/rofi-power-manager.sh
        ;;
    "$ROFI_HELP")
        open_in_ghostty_nvim ~/.config/rofi/help-manager/help-manager.rasi
        open_in_ghostty_nvim ~/.config/rofi/help-manager/rofi-help-manager.sh
        ;;
    "$KANSHI")
        open_in_ghostty_nvim ~/.config/kanshi/config
        ;;
esac

if [[ "$HOSTNAME" == "astra" ]]; then
    post_rofi &
fi
