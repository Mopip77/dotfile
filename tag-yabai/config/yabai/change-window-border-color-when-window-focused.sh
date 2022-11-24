#!/bin/bash

window_id="${YABAI_WINDOW_ID:-}"

read -r sticky floating <<< $(echo $(yabai -m query --windows --window $window_id | jq '."is-sticky", ."is-floating"'))

if [ "true" = $floating ]; then
  yabai -m config active_window_border_color 0xfc26A69A
elif [ "true" = $sticky ]; then
  yabai -m config active_window_border_color 0xfcDD87AE
else
  yabai -m config active_window_border_color 0xfcFFEE58
fi


