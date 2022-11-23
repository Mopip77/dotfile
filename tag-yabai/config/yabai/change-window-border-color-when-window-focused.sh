#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

window_id="${YABAI_WINDOW_ID:-}"

sticky=$(yabai -m query --windows --window $window_id | jq -r '."is-sticky"')

echo "window focused to:$window_id, sticky:$sticky" >> /tmp/window.log

if [ "true" = $sticky ]; then
  yabai -m config active_window_border_color   0xfcDD87AE
else
  yabai -m config active_window_border_color   0xfcFFEE58
fi


