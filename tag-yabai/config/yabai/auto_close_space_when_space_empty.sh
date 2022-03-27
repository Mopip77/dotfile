#!/bin/bash

space_index=$(yabai -m query --spaces --space | jq '.index')

if [[ -n $space_index && "0" != $space_index ]]; then
  active_window_count=$(yabai -m query --windows --space $space_index | jq 'map(select(."is-sticky" == false)) | length')
  if [[ -n $active_window_count && "0" = $active_window_count ]]; then
    ~/.config/yabai/destroy_space.sh
  fi
fi

