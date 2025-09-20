#!/bin/bash
# init needs to be ran in this specific script's folder
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

imp() {
    local path="$1"
    if [ -f "$path" ]; then
        set -a
        source $path
        set +a
    fi
}
imp "utils/import_print"
current_script=$(basename "$0")

if [ ! -d "$HOME/.local/bin" ]; then
    print_status "INFO" "~/.local/bin directory does not exist"
    mkdir -p ~/.local/bin
    print_status "INFO" "Created ~/.local/bin ..."
fi

changed_count=0
unchanged_count=0

for file in *; do
    [ "$file" = "$current_script" ] && continue
    [ ! -f "$file" ] && continue

    target_path="$HOME/.local/bin/$file"

    if [ -e "$target_path" ]; then
        # dont change
        ((unchanged_count++))
    else
        ln -s "${SCRIPT_DIR}/$file" "$target_path"
        ((changed_count++))
        print_status "OK" "Added $target_path"
    fi
done

print_status "OK" "Ignored: $unchanged_count, Added: $changed_count scripts"
