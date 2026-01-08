#!/bin/bash

sketchybar --add item clock right                              \
           --set clock   update_freq=10                        \
                         icon=                                \
                         icon.font="$FONT:Bold:20.0"      \
                         script="$PLUGIN_DIR/clock.sh"         \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
                                                               \
           --add item clock.separator right                    \
           --set clock.separator label="$SEPARATOR_R"          \
                         label.padding_left=$SEPARATOR_R_PADDING     \
                         label.padding_right=$SEPARATOR_R_PADDING    \
                         icon.drawing=off                      \
                         background.color="$BACKGROUND"
