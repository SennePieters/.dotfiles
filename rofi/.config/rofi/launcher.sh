#!/bin/bash

# --- Gather Status Info ---
TIME=$(date "+%H:%M")
DATE=$(date "+%a %d %b")

# Battery
if [ -d /sys/class/power_supply/BAT0 ]; then
    BAT_CAP=$(cat /sys/class/power_supply/BAT0/capacity)
    BAT_ICON=" "
    BAT_TEXT="$BAT_ICON $BAT_CAP%"
else
    BAT_TEXT=""
fi

# Volume
if command -v pamixer &> /dev/null; then
    VOL=$(pamixer --get-volume)
    VOL_ICON=" "
    VOL_TEXT="$VOL_ICON $VOL%"
else
    VOL_TEXT=""
fi

# Construct the side-panel message using Pango markup
# Big clock, smaller date, then battery/volume
MSG=$(printf "<span size='xx-large' weight='bold'>$TIME</span>\n<span size='large'>$DATE</span>\n\n$BAT_TEXT    $VOL_TEXT")

# Launch Rofi
# -mesg: The text for the sidebar
# -theme-str: Override placeholder to be standard again
rofi -show combi \
    -mesg "$MSG" \
    -theme-str 'entry { placeholder: "Search..."; }'
