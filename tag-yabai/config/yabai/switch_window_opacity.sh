#!/usr/bin/env bash

# Toggle a window's opacity between 0.6 and 1 and 0.

window_id=$(yabai -m query --windows --window | jq '.id')
window_config_file=/tmp/yabai-window-config-opacity-$window_id

# 定义透明度数组
opacities=(0.8 0.1 0.01 1.0)

# 读取当前窗口的透明度（如果存在的话）
if [ -e "$window_config_file" ]; then
    current_opacity=$(cat "$window_config_file")
else
    current_opacity=${opacities[0]}  # 默认透明度
fi

# 查找当前透明度在数组中的位置
current_index=-1
for i in "${!opacities[@]}"; do
   if [[ "${opacities[$i]}" == "${current_opacity}" ]]; then
       current_index=$i
       break
   fi
done

# 计算下一个透明度的位置
next_index=$((current_index + 1))

# 如果超出数组界限，回到数组的开始
if [ $next_index -ge ${#opacities[@]} ]; then
    next_index=0
fi

# 设置新的透明度
target_opacity=${opacities[$next_index]}

# 保存新的透明度
echo $target_opacity >"$window_config_file"

# 应用新的透明度到窗口
yabai -m window --opacity $target_opacity

#if [ ! -e "$window_config_file" ]; then
    #target_opacity=0.6
#else
    #read -r target_opacity <<<$(cat $window_config_file)
    #if [ "$target_opacity" = 0.6 ]; then
        #target_opacity=0.1
    #elif [ "$target_opacity" = 0.1 ]; then
        #target_opacity=0.01
    #elif [ "$target_opacity" = 0.01 ]; then
        #target_opacity=1.0
    #else
        #target_opacity=0.6
    #fi
#fi

#echo $target_opacity >"$window_config_file"

#yabai -m window --opacity $target_opacity
