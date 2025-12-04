#!/bin/bash
if ! command -v gum &> /dev/null; then
    echo "❌ Error: 'gum' is not installed."
    echo "Install with: go install github.com/charmbracelet/gum@latest"
    exit 1
fi

if ! command -v wlsunset &> /dev/null; then
    echo "❌ Error: 'wlsunset' is not installed."
    echo "Install with your package manager (e.g., pacman -S wlsunset)"
    exit 1
fi

LAT_LON_FILE="$HOME/.config/wlsunset/location"

PRIMARY="#cba6f7"
SECONDARY="#89b4fa"
SUCCESS="#a6e3a1"
WARNING="#f9e2af"
DANGER="#f38ba8"
ACCENT="#f5c2e7"
MUTED="#6c7086"

BTN_TOGGLE=" ╭─────────────────────────────╮
  │           Toggle            │
  ╰─────────────────────────────╯"
BTN_FORCE=" ╭─────────────────────────────╮
  │          Force On           │
  ╰─────────────────────────────╯"
BTN_CHANGE_LOC=" ╭─────────────────────────────╮
  │       Change Location       │
  ╰─────────────────────────────╯"
BTN_CHANGE_STR=" ╭─────────────────────────────╮
  │       Change Strength       │
  ╰─────────────────────────────╯"
BTN_EXIT=" ╭─────────────────────────────╮
  │            Exit             │
  ╰─────────────────────────────╯"

show_header() {
    TERM_WIDTH=$(tput cols)
    total_width=$((TERM_WIDTH - 2))
    # Main title box
    gum style \
        --foreground "$ACCENT" \
        --border-foreground "$ACCENT" \
        --border "rounded" \
        --width $total_width \
        --align "center" \
        --padding "2 0" \
        "🌅 NIGHT LIGHT 🌙"
    
    echo ""

    if pidof wlsunset > /dev/null; then
        status="  ACTIVE"
        foreground_color=$SUCCESS
    else
        status="  INACTIVE"
        foreground_color=$MUTED
    fi
    gum join --horizontal \
        "$(gum style --width $total_width --align "center" --foreground "$foreground_color" --padding "0 2" --margin "0 1" "$status")" \
    
    echo ""
}

get_status() {
    if pidof wlsunset > /dev/null; then
        echo "  ACTIVE"
    else
        echo "  INACTIVE"
    fi
}

show_menu() {
    term_width=$(tput cols)
    button_width=33
    padding=$(( (term_width - button_width) / 2 ))
    pad_str=$(printf "%*s" $padding "")
    
    # Pad each button using sed to add padding to every line
    padded_buttons=()
    for btn in "$BTN_TOGGLE" "$BTN_FORCE" "$BTN_CHANGE_LOC" "$BTN_CHANGE_STR" "$BTN_EXIT"; do
        padded_btn=$(echo "$btn" | sed "s/^/$pad_str/")
        padded_buttons+=("$padded_btn")
    done
    
    choice=$(gum choose \
        --header "" \
        --cursor " " \
        --cursor.foreground "$PRIMARY" \
        --selected.foreground "$SUCCESS" \
        --item.foreground "$SECONDARY" \
        "${padded_buttons[@]}")
    
    echo "$choice"
}

if [ -f "$LAT_LON_FILE" ]; then
    source "$LAT_LON_FILE"
else
    location=$(curl -s "https://ipinfo.io/loc")
    if [ ! -z "$location" ]; then
        LAT=$(echo "$location" | cut -d',' -f1)
        LON=$(echo "$location" | cut -d',' -f2)
    else
        # random default in LA
        LAT=34.0522
        LON=-118.2437
    fi
    echo -e "LAT=$LAT\nLON=$LON\nSTRENGTH=4750" > "$LAT_LON_FILE"
fi

expand_terminal() {
    # launching via rofi doesnt expand terminal at start
    gum style --width 120 " " > /dev/null 2>&1 || true
    gum style --width 120 --foreground "#00000000" " "
    printf "\033[1A\033[K"  # Move up and clear line
}

case "$1" in
    "init")
        # turn on
        wlsunset -l $LAT -L $LON -t $STRENGTH
        ;;
    *)
        expand_terminal
        show_header
        choice=$(show_menu)
        case "$choice" in
            *"Toggle"*)
                if pidof wlsunset > /dev/null; then
                    if killall wlsunset; then
                        gum style --foreground "$MUTED" "Disabled night light"
                        notify-send "wlsunset" " Disabled night light"
                    else
                        notify-send "wlsunset" " Failed to disable night light"
                    fi
                else
                    setsid wlsunset -l "$LAT" -L "$LON" -t $STRENGTH & disown
                    gum style --foreground "$SUCCESS" "Enabled night light"
                    notify-send "wlsunset" " Enabled night light"
                fi
                exit 0
                ;;
            *"Force"*)
                setsid wlsunset -s 00:00 -S 23:59 -t $STRENGTH & disown
                notify-send "wlsunset" " Force enabled night light"
                exit 0
                ;;
            *"Exit"*)
                clear
                gum style --foreground "$MUTED" --align "center" "👋 Goodbye!"
                exit 0
                ;;
            *)
                echo " choice not found"
                exit 0
                ;;
        esac
        ;;
esac
