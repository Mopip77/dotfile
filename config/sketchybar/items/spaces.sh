#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18")

spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))
  spaces+=(space.$sid)
  sketchybar --add space space.$sid left                                 \
             --set space.$sid associated_space=$sid                      \
                              icon=${SPACE_ICONS[i]}                     \
                              label.font="sketchybar-app-font:Regular:12.0" \
                              background.corner_radius=5                 \
                              background.height=20                       \
                              background.color=0x30ffffff               \
                              background.drawing=off                     \
                              script="$PLUGIN_DIR/space.sh"              \
                              click_script="yabai -m space --focus $sid" \
                              --subscribe space.$sid front_app_switched
done
