#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

if [[ -n "$SUDO_USER" ]]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME="$HOME"
fi

SOURCE_FILE="$USER_HOME/.config/hypr/reload-monitors.sh"
TARGET_LINK="/usr/local/bin/reload-monitors.sh"

# Check if source file exists
if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "Error: Source file does not exist: $SOURCE_FILE"
    exit 1
fi

# Check if source file is executable
if [[ ! -x "$SOURCE_FILE" ]]; then
    echo "Warning: Source file is not executable. Making it executable..."
    chmod +x "$SOURCE_FILE"
fi

# Create the symlink
echo "Creating symlink..."
sudo ln -sf "$SOURCE_FILE" "$TARGET_LINK"

if [[ $? -eq 0 ]]; then
    echo "✓ Symlink created successfully:"
else
    echo "✗ Failed to create symlink"
    exit 1
fi

RULE_FILE="/etc/udev/rules.d/99-hypr-monitor-hotplug.rules"
RULE_CONTENT='ACTION=="change", SUBSYSTEM=="drm", RUN+="/usr/local/bin/reload-monitors.sh"'

echo "$RULE_CONTENT" > "$RULE_FILE"

if [[ $? -eq 0 ]]; then
    echo "✓ Rule file created successfully at: $RULE_FILE"

    # Reload udev rules
    echo "Reloading udev rules..."
    udevadm control --reload-rules
    udevadm trigger

    echo "✓ Done! The monitor hotplug detection should now be active."
else
    echo "✗ Failed to create rule file"
    exit 1
fi
