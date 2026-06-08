#!/usr/bin/env bash
set -euo pipefail

CUSTOM_DIR="/home/kokopi/.config/qylock-ready"
UPSTREAM_DIR="/home/kokopi/.local/share/quickshell-lockscreen"
QML="$CUSTOM_DIR/lock_shell_ready.qml"
READY_FILE="$(mktemp -u "${XDG_RUNTIME_DIR:-/tmp}/qylock-ready.XXXXXX")"

cleanup() {
    rm -f "$READY_FILE"
}
trap cleanup EXIT

# Match upstream lock.sh environment setup
export QML2_IMPORT_PATH="$UPSTREAM_DIR/imports:${QML2_IMPORT_PATH:-}"
export QML_XHR_ALLOW_FILE_READ=1
export XDG_SESSION_TYPE="${XDG_SESSION_TYPE:-$(loginctl show-session "$(loginctl | grep "$(whoami)" | awk '{print $1}')" -p Type --value 2>/dev/null || echo wayland)}"

CONFIG_FILE="$HOME/.config/qylock/theme"
if [ -n "${1:-}" ]; then
    export QS_THEME="${1:-nier-automata}"
elif [ -f "$CONFIG_FILE" ]; then
    export QS_THEME="${1:-nier-automata}"
else
    export QS_THEME="${1:-nier-automata}"
fi

if [ -d "$UPSTREAM_DIR/../themes" ] && [ ! -d "$UPSTREAM_DIR/themes_link" ]; then
    export QS_THEME_PATH="$UPSTREAM_DIR/../themes/$QS_THEME"
else
    export QS_THEME_PATH="$UPSTREAM_DIR/themes_link/$QS_THEME"
fi

rm -f "$READY_FILE"
killall -9 hyprlock swaylock wlogout 2>/dev/null || true

QYLOCK_READY_FILE="$READY_FILE" quickshell -p "$QML" &
pid=$!

for _ in $(seq 1 200); do
    if [[ -e "$READY_FILE" ]]; then
        exit 0
    fi

    if ! kill -0 "$pid" 2>/dev/null; then
        wait "$pid"
        echo "qylock exited before becoming ready" >&2
        exit 1
    fi

    sleep 0.05
done

echo "qylock did not become ready in time" >&2
exit 1
