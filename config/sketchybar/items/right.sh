#/bin/bash

sketchybar --add item clock right                              \
           --set clock   update_freq=10                        \
                         icon=󰅐                                \
                         script="$PLUGIN_DIR/clock.sh"         \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
                                                               \
           --add item wifi right                               \
           --set wifi    script="$PLUGIN_DIR/wifi.sh"          \
                         icon=󰖩                                \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
           --subscribe wifi wifi_change                        \
                                                               \
           --add item volume right                             \
           --set volume  script="$PLUGIN_DIR/volume.sh"        \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
                         label.drawing=off                     \
           --subscribe volume volume_change                    \
                                                               \
           --add item battery right                            \
           --set battery script="$PLUGIN_DIR/battery.sh"       \
                         update_freq=120                       \
                         background.color="$BACKGROUND"        \
                         background.corner_radius=5            \
           --subscribe battery system_woke power_source_change
