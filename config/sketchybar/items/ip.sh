#/bin/bash

sketchybar --add item ip right                             \
           --set ip      update_freq=30                    \
                         script="$PLUGIN_DIR/ip.sh"        \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
                         icon.drawing=off \
                         click_script="ipconfig getifaddr en0 | tr -d '\n' | pbcopy && osascript -e 'display notification \"IP copied to clipboard\" with title \"IP Address\"'"

