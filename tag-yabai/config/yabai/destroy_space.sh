#!/bin/bash
PATH=$PATH:~/.local/bin

current_space_index="$(yabai -m query --spaces --space | jq '.index')"
recent_space_index="$(yabai -m query --spaces --space recent | jq '.index')"

#echo "recent: $(yabai -m query --spaces --space recent)" >> /tmp/T/ss.log
#echo "current: $(yabai -m query --spaces --space)" >> /tmp/T/ss.log

# 修复连续两次destroy space导致focus recent阻塞的bug
# 例如连续关闭space 3, 2
# 关闭space3，会跳转到space2，此时yabai对space3进行软删除，index置为0
# 再关闭space2时，跳转到space0，由于没有space0，命令阻塞
# 因此判断recent index是否等于0，如果为0，表示连续关闭space，但由于没有space stack，简单地focus prev处理
if [[ -z $recent_space_index || "0" = $recent_space_index ]]; then
  yabai -m space --focus prev || yabai -m space --focus last
else
  yabai -m space --focus recent
fi

yabai -m space "${current_space_index}" --destroy
spacebar -m config spaces on

