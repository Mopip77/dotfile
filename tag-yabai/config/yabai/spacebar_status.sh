#!/bin/bash

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
