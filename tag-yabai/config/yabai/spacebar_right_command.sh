#!/bin/bash

output_device() {
  output="`SwitchAudioSource -c`"

  case "$output" in
    "MacBook Pro扬声器")
      output="MBP"
      ;;
    "MOPIP'Airpods Pro")
      output="Pods Pro"
      ;;
    "MOPIP'AirPods")
      output="Pods"
      ;;
  esac
  echo $output
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

arr=(
# 这个软件有bug, 卡死后mac的sound直接不可用了
#"`output_device`"
"`volume`"
"`ip`"
#"`info`"
)

res=""

arrLength=${#arr[@]}
for ((i=0;i<${arrLength};i++))
do
  out=${arr[i]}
  [[ $i != $((arrLength - 1)) ]] && out="${out} | "
  res="$res$out"
done

echo $res
