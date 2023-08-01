#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

app_title=$(yabai -m query --windows --window | jq -r '.title')

sketchybar --set $NAME label="${app_title:0:60}"
