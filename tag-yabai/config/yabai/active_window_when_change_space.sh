#!/bin/bash

#active_window=$(yabai -m query --windows --space | jq first.id)
active_space=$(yabai -m query --windows --space | jq '.[] | select(."has-focus").space')
active_window=$(yabai -m query --windows --space | jq '.[] | select(."has-focus").id')


if [[ -z $active_window && 'null' != $active_window \
  && -z $active_space && 'null' != $active_space ]]; then
  # recheck 可能这个过程中space又改变了
  if [[ $active_space = $(yabai -m query --windows --space | jq '.[] | select(."has-focus").space') ]]; then
    yabai -m window --focus $active_window
  fi
fi
