#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# add any arg if you want to send current window to next display
send_window=${1:-}
all_display_indices_array=($(yabai -m query --displays | jq '.[].index | @sh' | tr -d \'\" | sort))

if [[ 1 -eq ${#all_display_indices_array[@]} ]]; then
  # only one display, do not move
  exit 1
fi

current_display_index=$(yabai -m query --displays --display | jq '.index')

# get next display display by cycle
for idx in "${!all_display_indices_array[@]}"; do
  if [[ $current_display_index -eq ${all_display_indices_array[idx]} ]]; then
      next_display_index=$(( (idx + 1) % ${#all_display_indices_array[@]} ))
    break
  fi
done

if [[ -n ${next_display_index:+x} ]]; then
  index=${all_display_indices_array[next_display_index]}
  if [ -n "$send_window" ]; then
    yabai -m window --display $index
  fi
  yabai -m display --focus $index
fi
