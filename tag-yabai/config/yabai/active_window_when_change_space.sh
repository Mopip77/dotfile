#!/bin/bash

new_space_id=$1
old_space_id=$2

new_space_index=$(yabai -m query --spaces | jq 'map(select(.id == '${new_space_id}'))[0].index')

if [[ -z $new_space_index || 'null' = $new_space_index ]]; then
  exit 0
fi

# 原先active的窗口
active_window=$(yabai -m query --windows --space $new_space_index | jq 'map(select(."is-sticky" == false and ."has-focus"))[0].id')

if [[ -z $active_window || 'null' = $active_window ]]; then
  # 原先active窗口不属于当前space，选取当前space最新的window
  active_window=$(yabai -m query --windows --space $new_space_index | jq 'map(select(."is-sticky" == false)) | max_by(.id) | .id')
fi

if [[ -n $active_window && 'null' != $active_window ]]; then
  # recheck 可能这个过程中space又改变了
  if [[ $new_space_id = $(yabai -m query --spaces --space | jq '.id') ]]; then
    yabai -m window --focus $active_window
  fi
fi
