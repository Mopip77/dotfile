#/bin/bash

sketchybar --add item output_devices right                             \
           --set output_devices      update_freq=5                    \
                         script="$PLUGIN_DIR/output_devices.sh"        \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
                         icon.drawing=off
