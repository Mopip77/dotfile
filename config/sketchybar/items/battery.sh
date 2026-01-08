#!/bin/bash

sketchybar --add item battery right                            \
           --set battery script="$PLUGIN_DIR/battery.sh"       \
                         update_freq=120                       \
                         icon.font="$FONT:Bold:20.0"      \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
           --subscribe battery system_woke power_source_change \
                                                               \
           --add item battery.separator right                  \
           --set battery.separator label="$SEPARATOR_R"        \
                         label.padding_left=$SEPARATOR_R_PADDING     \
                         label.padding_right=$SEPARATOR_R_PADDING    \
                         icon.drawing=off                      \
                         background.color="$BACKGROUND"
