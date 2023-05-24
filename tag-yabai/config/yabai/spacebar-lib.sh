#!/bin/bash

output_device() {
  output="`SwitchAudioSource -c`"

  case "$output" in
    MacBook*)
      output="🔈 MAC"
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

volume() {
  volume=$(osascript -e 'output volume of (get volume settings)')
  [[ $volume = "0" ]] && volume="mute"
  echo " ${volume}"
}

info() {
  echo "Mopip77"
}

ip() {
  osascript -e "IPv4 address of (system info)"
}

shurufa() {
  curPath=$(cd `dirname $0`; pwd)
  layout=$(${curPath}/get_current_shurufa)
  if [[ $layout == *"ABC"* ]];then
     echo "🇺🇸 "
  else
     echo "🇨🇳 "
  fi
}

now_playing() {
    IFS=$'\n' read -r -d$'\1' isPlaying title <<< "$(nowplaying-cli get playbackRate title)"
    if [ "1" = "$isPlaying" ]; then
        echo "📻 [$title]"
    fi
}
