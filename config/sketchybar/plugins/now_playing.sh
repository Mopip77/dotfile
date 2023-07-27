#!/bin/sh

IFS=$'\n' read -r -d$'\1' isPlaying title artist <<< "$(nowplaying-cli get playbackRate title artist)"

if [[ $isPlaying != "1" ]]; then
    sketchybar --set $NAME label="" icon=""
else
    sketchybar --set $NAME label="$title - $artist" icon="📻"
fi

