#!/bin/bash
set -x
# restore_opacity_watcher.sh

CACHE_FILE="$HOME/.config/hypr/scripts/opacity_cache"

mkdir -p "$(dirname "$CACHE_FILE")"
touch "$CACHE_FILE"

hyprctl events | while read -r line; do
    echo "[DEBUG] Event: $line"
    if [[ "$line" == *"destroyed"* ]]; then
        echo "[DEBUG] Detected destroyed event"
        # Check cached windows
        while IFS=: read -r addr orig class state; do
            echo "[DEBUG] Cache entry: addr=$addr orig=$orig class=$class state=$state"
            exists=$(hyprctl clients -j | grep "\"address\": \"$addr\"")
            echo "[DEBUG] Exists: $exists"
            if [ -z "$exists" ]; then
                echo "[DEBUG] Window $addr not found, restoring opacity for class $class"
                # Restore opacity for all currently open windows of this class
                for win_addr in $(hyprctl clients -j | jq -r ".[] | select(.class==\"$class\") | .address"); do
                    echo "[DEBUG] Restoring opacity for $win_addr"
                    hyprctl dispatch opacity "$win_addr" "$orig"
                    echo "[restore_opacity_watcher] Restored opacity $orig for $class ($win_addr)"
                done
                # Remove only the destroyed window's cache entry
                grep -v "^$addr:" "$CACHE_FILE" > "$CACHE_FILE.tmp" && mv "$CACHE_FILE.tmp" "$CACHE_FILE"
                echo "[DEBUG] Removed cache entry for $addr"
            fi
        done < "$CACHE_FILE"
    fi
done
