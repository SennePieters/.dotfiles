#!/bin/bash

# Power Options with sorting prefix (\u200b) to ensure they are at the top
shutdown="$(printf '\u200b') ⏻  Shutdown"
reboot="$(printf '\u200b')   Reboot"
lock="$(printf '\u200b')   Lock"
suspend="$(printf '\u200b')   Suspend"
logout="$(printf '\u200b')   Logout"

# --- Output or Handle ---
if [ -z "$@" ]; then
    echo -en "$lock\0icon\x1fsystem-lock-screen\n"
    echo -en "$suspend\0icon\x1fsystem-suspend\n"
    echo -en "$logout\0icon\x1fsystem-log-out\n"
    echo -en "$reboot\0icon\x1fsystem-reboot\n"
    echo -en "$shutdown\0icon\x1fsystem-shutdown\n"
else
    # Handle clicks
    case "$1" in
        *"Shutdown") systemctl poweroff ;;
        *"Reboot") systemctl reboot ;;
        *"Lock") pidof hyprlock || hyprlock ;;
        *"Suspend") systemctl suspend ;;
        *"Logout") hyprctl dispatch exit ;;
    esac
fi
