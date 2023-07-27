#/bin/bash

sketchybar --add item volume right                             \
           --set volume  script="$PLUGIN_DIR/volume.sh"        \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
           --subscribe volume volume_change                    \

