#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

output_device() {
  output="`SwitchAudioSource -c`"

  case "$output" in
    MacBook*)
      output="🔈 MAC"
      ;;
    "MCPP的AirPods Pro")
      output="🎧 pro"
      ;;
    "MOPIP'Airpods Pro")
      output="🎧 pro"
      ;;
    "MOPIP'AirPods")
      output="🎧 pods"
      ;;
    "OPPO Enco Free2")
      output="🎧 OPPO"
      ;;
    "OpenRun by Shokz")
      output="Shokz"
      ;;
  esac
  echo "$output"
}

sketchybar --set $NAME label="$(output_device)"
