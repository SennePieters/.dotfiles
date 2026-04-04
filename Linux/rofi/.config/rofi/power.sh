#!/bin/bash

# Define the options
shutdown="⏻ Shutdown"
reboot=" Reboot"
lock=" Lock"
suspend=" Suspend"
logout=" Logout"

# If no argument is passed, output the options
# The \0icon\x1f syntax sets the icon for the entry
if [ -z "$@" ]; then
    echo -en "$lock\0icon\x1fsystem-lock-screen\n"
    echo -en "$suspend\0icon\x1fsystem-suspend\n"
    echo -en "$logout\0icon\x1fsystem-log-out\n"
    echo -en "$reboot\0icon\x1fsystem-reboot\n"
    echo -en "$shutdown\0icon\x1fsystem-shutdown\n"
else
    # Handle the selection
    case "$1" in
        "$shutdown") systemctl poweroff ;;
        "$reboot") systemctl reboot ;;
        "$lock") pidof hyprlock || hyprlock ;;
        "$suspend") systemctl suspend ;;
        "$logout") hyprctl dispatch exit ;;
    esac
fi
