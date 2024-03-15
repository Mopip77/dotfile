#!/usr/bin/env bash

# Toggle a window's opacity between 0.6 and 1 and 0.

window_id=$(yabai -m query --windows --window | jq '.id')
window_config_file=/tmp/yabai-window-config-opacity-$window_id

if [ ! -e "$window_config_file" ]; then
    target_opacity=0.6
else
    read -r target_opacity <<<$(cat $window_config_file)
    if [ "$target_opacity" = 0.6 ]; then
        target_opacity=0.01
    elif [ "$target_opacity" = 0.01 ]; then
        target_opacity=1.0
    else
        target_opacity=0.6
    fi
fi

echo $target_opacity >"$window_config_file"

yabai -m window --opacity $target_opacity
