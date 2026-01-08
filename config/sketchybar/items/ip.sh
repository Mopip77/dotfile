#/bin/bash

sketchybar --add item ip right                             \
           --set ip      update_freq=30                    \
                         script="$PLUGIN_DIR/ip.sh"        \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
                         icon.drawing=off

