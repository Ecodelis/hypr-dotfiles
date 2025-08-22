#!/bin/bash
# toggle_opacity.sh

CACHE_FILE="$HOME/.config/hypr/scripts/opacity_cache"

mkdir -p "$(dirname "$CACHE_FILE")"
touch "$CACHE_FILE"

# Active window info
win_class=$(hyprctl activewindow -j | grep '"class":' | head -n1 | sed 's/.*: "\(.*\)".*/\1/')
win_addr=$(hyprctl activewindow -j | grep '"address":' | head -n1 | sed 's/.*: "\(.*\)".*/\1/')

if [ -z "$win_class" ] || [ "$win_class" == "null" ]; then
    echo "Could not detect active window class"
    exit 1
fi

# Current opacity
current_opacity=$(hyprctl activewindow -j | grep '"opacity":' | sed 's/.*: \(.*\),/\1/')
if [ -z "$current_opacity" ]; then
    current_opacity=1.0
fi

# Read cache
line=$(grep "^$win_addr:" "$CACHE_FILE")
if [ -z "$line" ]; then
    # No entry yet, save original opacity and class, set to 0.1
    echo "$win_addr:$current_opacity:$win_class:toggled" >> "$CACHE_FILE"
    new_opacity=0.1
else
    # Entry exists, check state
    original_opacity=$(echo "$line" | cut -d':' -f2)
    cached_class=$(echo "$line" | cut -d':' -f3)
    state=$(echo "$line" | cut -d':' -f4)

    if [ "$state" == "toggled" ]; then
        # Restore original opacity
        new_opacity=$original_opacity
        state="original"
    else
        # Set to 0.1 again
        new_opacity=0.1
        state="toggled"
    fi

    # Update cache
    grep -v "^$win_addr:" "$CACHE_FILE" > "$CACHE_FILE.tmp"
    echo "$win_addr:$original_opacity:$cached_class:$state" >> "$CACHE_FILE.tmp"
    mv "$CACHE_FILE.tmp" "$CACHE_FILE"
fi

# Apply opacity
hyprctl keyword windowrulev2 "opacity $new_opacity $new_opacity, class:^$win_class$"
echo "Applied opacity $new_opacity to class '$win_class'"
