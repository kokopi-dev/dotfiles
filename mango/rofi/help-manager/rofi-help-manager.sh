#!/bin/bash
THEME_FILE=~/.config/rofi/help-manager/help-manager.rasi
post_rofi() {
    local image_dir="$HOME/.config/rofi/images/neco"
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

SYSTEM="󰟀   System"
NVIM="   Neovim"
BASH_HELP="   Bash"
chosen=$(echo -e "$SYSTEM\n$NVIM\n$BASH_HELP" | rofi -mesg " Keybinds" -dmenu -p "Action:" -config ~/.config/rofi/config-manager/config-manager.rasi)

case $chosen in
"$NVIM")
    cat ~/.config/rofi/help-manager/neovim-keybinds.txt | rofi -mesg "  Neovim Binds" -dmenu -i -p "󰍉" -config $THEME_FILE \
        -font "Geist Mono 14" \
        -kb-accept-entry ""
    ;;
"$SYSTEM")
    cat ~/.config/rofi/help-manager/system-keybinds.txt | rofi -mesg "  System Binds" -dmenu -i -p "󰍉" -config $THEME_FILE \
        -font "Geist Mono 14" \
        -kb-accept-entry ""
    ;;
"$BASH_HELP")
    if [ ! -d "/tmp/firefox-dev" ]; then
        echo "Creating firefox profile"
        mkdir -p /tmp/firefox-dev
        firefox -CreateProfile "dev-profile /tmp/firefox-dev"
        cat >> /tmp/firefox-dev/prefs.js << EOF
user_pref("browser.download.dir", "~/downloads");
user_pref("browser.download.folderList", 2);
EOF
    fi

    firefox -P dev-profile -private-window https://devhints.io/bash &
    ;;
esac

if [[ "$HOSTNAME" == "astra" ]]; then
    post_rofi &
fi
