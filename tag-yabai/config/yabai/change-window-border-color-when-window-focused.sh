#!/usr/bin/env bash

window_id="${YABAI_WINDOW_ID:-}"

read -r subrole sticky floating <<< $(echo $(yabai -m query --windows --window $window_id | jq -r '.subrole, ."is-sticky", ."is-floating"'))

if [[ "AXSystemDialog" = "$subrole" ]]; then
    exit 0
fi

if [[ "true" = $floating ]]; then
  #  yabai -m config active_window_border_color 0xfc26A69A
  borders active_color=0xfc26a69a inactive_color=0x00494d64 width=4.0 &
elif [[ "true" = $sticky ]]; then
  #yabai -m config active_window_border_color 0xfcDD87AE
  borders active_color=0xfcdd87ae inactive_color=0x00494d64 width=4.0 &
else
  #yabai -m config active_window_border_color 0xfcFFEE58
  borders active_color=0xfcffee58 inactive_color=0x00494d64 width=4.0 &
fi


