#/bin/bash

sketchybar --add item now_playing left                              \
           --set now_playing     update_freq=3                        \
                                 script="$PLUGIN_DIR/now_playing.sh"   \
                                 icon.font="$FONT:Bold:20.0"      \
                                 background.drawing=off        \
                                 background.color="$BACKGROUND"        \
                                 background.corner_radius=5            \

