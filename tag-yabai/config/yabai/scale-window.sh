#!/bin/bash

###
#
# 保持窗口大小比例，放大或缩小窗口
#
###

# 用法：scale-window.sh <zoom_type> <zoom_ratio>

# zoom_type: 放大或缩小 "in" 或 "out"
zoom_type=$1
# zoom_ratio: 缩放比例 eg: 0.1
zoom_ratio=$2

read -r floating x y w h < <(yabai -m query --windows --window | jq -r '"\(."is-floating") \(.frame.x) \(.frame.y) \(.frame.w) \(.frame.h)"')

if [ "$floating" = "false" ]; then
    echo "Window is not floating"
    exit 0
fi

if [ "$zoom_type" = "in" ]; then
    w=$(bc <<< "scale=0; $w + $w * $zoom_ratio")
    h=$(bc <<< "scale=0; $h + $h * $zoom_ratio")
    x=$(bc <<< "scale=0; $x - $w * $zoom_ratio / 2")
    y=$(bc <<< "scale=0; $y - $h * $zoom_ratio / 2")
elif [ "$zoom_type" = "out" ]; then
    w=$(bc <<< "scale=0; $w - $w * $zoom_ratio")
    h=$(bc <<< "scale=0; $h - $h * $zoom_ratio")
    x=$(bc <<< "scale=0; $x + $w * $zoom_ratio / 2")
    y=$(bc <<< "scale=0; $y + $h * $zoom_ratio / 2")
else
    echo "Invalid zoom type"
    exit 1
fi

yabai -m window --resize abs:"$w":"$h"
yabai -m window --move abs:"$x":"$y"