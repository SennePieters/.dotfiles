#!/bin/bash

# This script listens for window focus changes and closes the special workspace
# if a window on a normal workspace is focused.
# Requires: socat, jq

last_run=0

handle() {
  case $1 in
    workspace*)
      if [[ "${1#*>>}" == "special:"* ]]; then return; fi
      ;;
    focusedmon*)
      # focusedmon>>MONITOR,WORKSPACE
      local args=${1#*>>}
      local ws=${args#*,}
      if [[ "$ws" == "special:"* ]]; then return; fi
      ;;
    activewindow*)
      # activewindow>>CLASS,TITLE
      # Check if the focused window is on a special workspace
      local active_ws=$(hyprctl activewindow -j | jq -r '.workspace.name')
      if [[ "$active_ws" == "special:"* ]]; then return; fi
      ;;
    *)
      return
      ;;
  esac

  # Debounce: prevent double-toggling if multiple events fire at once
  local now=$(date +%s%3N)
  if (( now - last_run < 100 )); then return; fi

  # Get all monitor info once to be more efficient
  local monitor_info=$(hyprctl monitors -j)
  local open_specials=$(echo "$monitor_info" | jq -r '.[] | select(.specialWorkspace.name | startswith("special:")) | .name + " " + .specialWorkspace.name')

  # If no special workspaces are open, do nothing.
  if [[ -z "$open_specials" ]]; then
    return
  fi

  # A special workspace needs to be closed. Update timestamp to enforce cooldown.
  last_run=$now
  
  local target_mon=$(echo "$monitor_info" | jq -r '.[] | select(.focused == true) | .name')

  # For each open special, atomically focus its monitor, toggle it, and focus back.
  while read -r mon_name spec_full; do
    local spec_name="${spec_full#special:}"
    hyprctl --batch "dispatch focusmonitor $mon_name; dispatch togglespecialworkspace $spec_name; dispatch focusmonitor $target_mon"
  done <<< "$open_specials"
}

socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do handle "$line"; done
