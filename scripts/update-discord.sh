#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: $0 <string_to_check>"
	echo "Example: $0 discord-0.0.20.tar.gz"
	exit 1
fi

func_validate_filename() {
    # Convert to lowercase for case-insensitive matching
    local lower_input=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    # Check if both "discord" and ".deb" are present
    if [[ "$lower_input" == *"discord"* ]] && [[ "$lower_input" == *".tar.gz"* ]]; then
        echo "✓ Updated Discord with file: '$1'"
        return 0
    else
        echo "✗ No match: '$1' does not contain both 'discord' and '.tar.gz'"
        
        # Provide specific feedback
        if [[ "$lower_input" != *"discord"* ]]; then
            echo "  - Missing 'discord' ✗"
        fi
        
        if [[ "$lower_input" != *".deb"* ]]; then
            echo "  - Missing '.deb' ✗"
        fi
        
        return 1
    fi
}

if func_validate_filename "$1"; then
    sudo tar -xzf "$1"
    sudo rm -rf /opt/discord
    sudo mv Discord /opt/discord
    sudo ln -sf /opt/discord/Discord /usr/bin/discord
fi

#TODO check for .desktop file and create if not exists
