#!/usr/bin/env bash

CURRENT_DESKTOP=
RANDOM_FOLDER="${HOME}/Pictures/wallpaper"

acquire_current_desktop() {
  local currentDisplayIndex=$(yabai -m query --displays --display | jq '.index')
  case $currentDisplayIndex in
    1)
      CURRENT_DESKTOP="current"
      ;;
    2)
      CURRENT_DESKTOP="second"
      ;;
    3)
      CURRENT_DESKTOP="third"
      ;;
  esac
}

change_random_wallpaper() {
  acquire_current_desktop
  if [ -d $RANDOM_FOLDER ];
  then
    # 分批打乱两次
    wallpaper=$(ls $RANDOM_FOLDER | shuf -n 5 | shuf -n 1)
    echo "change new wallpaper ${wallpaper}, display: ${CURRENT_DESKTOP}"

    osascript -e "
      tell application \"System Events\"
        tell ${CURRENT_DESKTOP} desktop
          set picture to \"${RANDOM_FOLDER}/${wallpaper}\"
        end tell
      end tell
    "
  fi
}

echo "$0 executed."

change_random_wallpaper
