#!/usr/bin/env bash

# Toggle a window between floating and tiling.
# Only works when the workspace layout is bsp, i.e., the windows in it are tiled.

spaceType=$(yabai -m query --spaces --space | jq .type)
if [ $spaceType = '"bsp"' ]; then

  read -r id sticky <<< $(echo $(yabai -m query --windows --window | jq '.id, ."is-sticky"'))
  tmpfile=/tmp/yabai-tiling-floating-toggle/sticky-$id

  # border=$(yabai -m config window_border)

  # If the window is floating, record its position and size into a temp file and toggle it to be tiling.
  if [[ $sticky = true ]]
  then
    [ -e $tmpfile ] && rm $tmpfile
    echo $(yabai -m query --windows --window | jq .frame) >> $tmpfile
    yabai -m window --toggle sticky \
    && yabai -m window --toggle topmost
  else
    yabai -m window --toggle sticky \
    && yabai -m window --toggle topmost
    if [ -e $tmpfile ]
    then
      read -r x y w h <<< $(echo $(cat $tmpfile | jq '.x, .y, .w, .h'))
      yabai -m window --move abs:$x:$y
      yabai -m window --resize abs:$w:$h
      rm $tmpfile
    else
      display=$(yabai -m query --windows --window | jq .display)
      . /tmp/yabai-tiling-floating-toggle/display-$display
       #move to top right corner
      yabai -m window --move abs:$((w*4/5)):$((h/23))
      yabai -m window --resize abs:$((w*3/5)):$((h*3/5))
    fi
  fi

fi
