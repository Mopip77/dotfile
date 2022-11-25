#!/bin/bash

# Yabai should auto focus on new window after one window destroyed.
# But in some scenario, yabai will not auto focus. Eg. close window between floating and bsp window.

# So if yabai doesn't auto focus after window destroyed, do it mannually.

# If the destroyed window is dialog(like guage or eudic), ignore.
yabai_subrole=$(yabai -m query --windows --window $YABAI_WINDOW_ID | jq -r '.subrole') || yabai_subrole=false
if [[ "AXSystemDialog" = "$yabai_subrole" ]]; then
  exit 0
fi

# It is weird to query twice, cause some active window can only be quired out with `--window` option.
hasFocused=$(yabai -m query --windows --window | jq '."has-focus"') || hasFocused=false
if [[ "true" != $hasFocused ]]; then
  hasFocused=$(yabai -m query --windows | jq '.[] | select(."has-focus" and ."is-visible") | ."has-focus"') || hasFocused=false
fi

if [[ "true" != $hasFocused ]]; then
  yabai -m window --focus $(yabai -m query --windows --space | jq .[0].id)
fi
