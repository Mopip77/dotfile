#!/usr/bin/env bash

# 如果当前window不处于stack状态则优先和上下的窗口进行合并，否则和左右的窗口进行合并
# 如果当前window处于stack状态，则执行两次float，使其脱离stack（因为没有直接exit stack的方法）

isStack=$(yabai -m query --windows --window | jq '."stack-index"')

if [ $isStack -eq 0 ]
then
  windowId=$(yabai -m query --windows --window | jq -r '.id')
  # 优先和上面或者下面的窗口stack，其次和左右的窗口stack
  yabai -m window north --stack $windowId \
  || yabai -m window south --stack $windowId \
  || yabai -m window west --stack $windowId \
  || yabai -m window east --stack $windowId
else
  echo "haha"
  yabai -m window --toggle float && yabai -m window --toggle float
fi
