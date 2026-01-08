#!/bin/bash

sketchybar --add item volume right                             \
           --set volume  script="$PLUGIN_DIR/volume.sh"        \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
                         click_script="osascript -e 'set volume output muted not (output muted of (get volume settings))'" \
           --subscribe volume volume_change                    \
                                                               \
           --add item volume.separator right                   \
           --set volume.separator label="$SEPARATOR_R"         \
                         label.padding_left=$SEPARATOR_R_PADDING     \
                         label.padding_right=$SEPARATOR_R_PADDING    \
                         icon.drawing=off                      \
                         background.color="$BACKGROUND"
