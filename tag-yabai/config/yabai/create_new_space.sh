#!/bin/bash

## 创建一个新的space
## arg[0] == 1, 将当前窗口移动至新的space

if [ ${1:-} = "1" ]; then
  moveCurrentWindow="yes"
fi

yabai -m space --create

[[ ! -z $moveCurrentWindow ]] && windowId="$(yabai -m query --spaces --display | jq 'map(select(."has-focus"))[-1].id')"
spaceIndex="$(yabai -m query --spaces --display | jq 'map(select (."is-native-fullscreen" == false))[-1].index')"

if [[ ! -z $moveCurrentWindow && ! -z $windowId && $windowId != 'null' ]]
then
  yabai -m window --space ${spaceIndex}
fi

yabai -m space --focus ${spaceIndex}
~/.config/yabai/change-random-wallpaper.sh
