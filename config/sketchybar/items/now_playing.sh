#/bin/bash

sketchybar --add item now_playing center                              \
           --set now_playing     update_freq=3                        \
                                 script="$PLUGIN_DIR/now_playing.sh"   \
                                 background.drawing=off        \
                                 background.color="$BACKGROUND"        \
                                 background.corner_radius=5            \

