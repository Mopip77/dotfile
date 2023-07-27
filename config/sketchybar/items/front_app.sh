#!/bin/bash

sketchybar \
           --add item front_app center                               \
           --set front_app       script="$PLUGIN_DIR/front_app.sh" \
                                 icon.drawing=off                  \
                                 background.color="$BACKGROUND"    \
           --subscribe front_app front_app_switched
