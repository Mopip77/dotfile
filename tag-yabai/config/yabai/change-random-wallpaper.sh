#!/usr/bin/env bash

RANDOM_FOLDER="${HOME}/Pictures/wallpaper"

if [ -d $RANDOM_FOLDER ];
then
  # 分批打乱两次
  wallpaper=$(ls $RANDOM_FOLDER | shuf -n 5 | shuf -n 1)
  echo "change new wallpaper ${wallpaper}"
  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'${RANDOM_FOLDER}/${wallpaper}'"'
fi
