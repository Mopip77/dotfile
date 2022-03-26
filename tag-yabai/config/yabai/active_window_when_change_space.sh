#!/bin/bash

active_space=$(yabai -m query --windows --space | jq '.[] | select(."has-focus").space')
active_window=$(yabai -m query --windows --space | jq '.[] | select(."has-focus").id')

if [[ -n $active_window && 'null' != $active_window \
  && -n $active_space && 'null' != $active_space ]]; then
  # recheck 可能这个过程中space又改变了
  if [[ $active_space = $(yabai -m query --windows --space | jq '.[] | select(."has-focus").space') ]]; then
    yabai -m window --focus $active_window
  fi
fi
