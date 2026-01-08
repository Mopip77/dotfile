#!/bin/bash

sketchybar \
           --add item front_app center                               \
           --set front_app       script="$PLUGIN_DIR/front_app.sh" \
                                 icon.drawing=off                  \
                                 background.color="$BACKGROUND"    \
                                 click_script="yabai -m query --windows --window | pbcopy && osascript -e 'display notification \"Window info copied to clipboard\" with title \"Yabai Debug\"'" \
           --subscribe front_app front_app_switched
