#!/bin/bash

sketchybar --add item clock right                              \
           --set clock   update_freq=10                        \
                         icon=󰅐                                \
                         icon.font="$FONT:Bold:20.0"      \
                         script="$PLUGIN_DIR/clock.sh"         \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
