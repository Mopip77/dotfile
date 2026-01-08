#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.


output="`SwitchAudioSource -c`"
icon="󰓃"

case "$output" in
  MacBook*)
    output="MAC"
    icon="󰓃"
    ;;
  "MCPP的AirPods Pro")
    output="pro"
    icon="󰋋"
    ;;
  "MOPIP'Airpods Pro")
    output="pro"
    icon="󰋋"
    ;;
  "MOPIP'AirPods")
    output="pods"
    icon="󰋋"
    ;;
  "OPPO Enco Free2")
    output="OPPO"
    icon="󰋋"
    ;;
esac

sketchybar --set $NAME label="$output" icon="$icon"
