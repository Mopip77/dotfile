#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))
  spaces+=(space.$sid)
  sketchybar --add space space.$sid left                                 \
             --set space.$sid associated_space=$sid                      \
                              icon=${SPACE_ICONS[i]}                     \
                              background.corner_radius=5                 \
                              background.height=20                       \
                              background.color=0x30ffffff               \
                              background.drawing=off                     \
                              label.drawing=off                          \
                              script="$PLUGIN_DIR/space.sh"              \
                              click_script="yabai -m space --focus $sid"
done


sketchybar --add item space_separator left                         \
           --set space_separator icon=                            \
                                 padding_left=10                   \
                                 padding_right=10                  \
                                 label.drawing=off                 \
                                                                   \
           --add item front_app left                               \
           --set front_app       script="$PLUGIN_DIR/front_app.sh" \
                                 icon.drawing=off                  \
                                 background.color="$BACKGROUND"    \
           --subscribe front_app front_app_switched


sketchybar --add bracket spaces "${spaces[@]}" space_separator front_app \
           --set spaces background.color=$BACKGROUND \
                        background.corner_radius=5   \
                        background.height=30
