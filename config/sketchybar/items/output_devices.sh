#!/bin/bash

sketchybar --add item output_devices right                             \
           --set output_devices     \
                         update_freq=15                    \
                         script="$PLUGIN_DIR/output_devices.sh"        \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
                         click_script="open raycast://extensions/benvp/audio-device/set-output-device" \
                                                               \
           --add item output_devices.separator right          \
           --set output_devices.separator label="$SEPARATOR_R" \
                         label.padding_left=$SEPARATOR_R_PADDING     \
                         label.padding_right=$SEPARATOR_R_PADDING    \
                         icon.drawing=off                      \
                         background.color="$BACKGROUND"
