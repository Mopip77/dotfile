#!/usr/bin/env bash

echo "==================== next =================="

set -x

# Toggle a window between floating and tiling.
# Only works when the workspace layout is bsp, i.e., the windows in it are tiled.
mouseSpaceIndex=$(yabai -m query --spaces --space mouse | jq -r .index)
windowSpaceIndex=$(yabai -m query --windows --window | jq -r .space)

spaceType=$(yabai -m query --spaces --space $mouseSpaceIndex | jq -r .type)
if [ $spaceType = "bsp" ]; then

  read -r id isFloating <<< $(echo $(yabai -m query --windows --window | jq -r '.id, ."is-floating"'))
  tmpfile=/tmp/yabai-tiling-floating-toggle/$id

  # set flag variable
  isSameSpace=true && [ $mouseSpaceIndex = $windowSpaceIndex ] || isSameSpace=false

  # toggle between bsp and float
  [[ $isFloating != true ]] && yabai -m window --toggle float
  # move window to mouse space
  [[ $isSameSpace != true ]] && yabai -m window --space $mouseSpaceIndex

  display=$(yabai -m query --spaces --space $mouseSpaceIndex | jq .display)
  . /tmp/yabai-tiling-floating-toggle/display-$display
  yabai -m window --move abs:$x:$y
  yabai -m window --resize abs:$w:$h
fi
