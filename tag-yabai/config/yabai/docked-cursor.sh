#!/bin/bash

# --- 配置 ---
WINDOW_TITLE=".docked-cursor"
SCRATCHPAD_DIR="$HOME/.docked-cursor"
LAST_WINDOW_ID_FILE="$SCRATCHPAD_DIR/.last_window"
EDITOR_COMMAND="cursor"
EDITOR_APP="Cursor"

# 确保目录存在
mkdir -p "$SCRATCHPAD_DIR"

# --- 主逻辑 ---

# 首先，尝试找到目标窗口
TARGET_WINDOW=$(yabai -m query --windows | jq --arg title "$WINDOW_TITLE" '.[] | select(.app == "'$EDITOR_APP'" and (.title | contains($title)))')
WINDOW_ID=$(echo "$TARGET_WINDOW" | jq -r '.id')

# 模式一：编辑流程 (带 "edit" 参数)
if [ "$1" == "edit" ]; then
    # 通过窗口是否已聚焦来判断是流程的第一步还是第二步
    if [ -n "$WINDOW_ID" ] && [ "$(echo "$TARGET_WINDOW" | jq -r '."has-focus"')" = "true" ]; then
        # --- 第二步：完成编辑，粘贴内容 ---
        echo "Step 2: Copying content from editor and pasting back."

        # 1. 从编辑器窗口复制所有内容
        osascript -e 'tell application "System Events" to tell process "'$EDITOR_APP'" to keystroke "a" using {command down}'
        sleep 0.1
        osascript -e 'tell application "System Events" to tell process "'$EDITOR_APP'" to keystroke "c" using {command down}'
        sleep 0.1
        
        # 2. 最小化光标窗口
        yabai -m window "$WINDOW_ID" --minimize

        # 3. 聚焦回原来的窗口
        if [ -f "$LAST_WINDOW_ID_FILE" ]; then
            ORIGINAL_WINDOW_ID=$(cat "$LAST_WINDOW_ID_FILE")
            yabai -m window --focus "$ORIGINAL_WINDOW_ID"
            rm "$LAST_WINDOW_ID_FILE"
        fi

        # 4. 模拟粘贴
        sleep 0.2
        osascript -e 'tell application "System Events" to keystroke "v" using {command down}'

    else
        # --- 第一步：复制选中内容，打开编辑器并粘贴 ---
        echo "Step 1: Copying selection and pasting into editor."

        # 1. 记录当前聚焦的窗口ID，以便后续返回
        yabai -m query --windows --window | jq '.id' > "$LAST_WINDOW_ID_FILE"

        # 2. 模拟复制操作
        osascript -e 'tell application "System Events" to keystroke "c" using {command down}'
        sleep 0.1

        # 3. 显示并聚焦窗口 (如果不存在则创建)
        if [ -z "$WINDOW_ID" ]; then
            # 启动并等待
            $EDITOR_COMMAND "$SCRATCHPAD_DIR" & 
            for i in {1..20}; do
                sleep 0.25
                WINDOW_ID=$(yabai -m query --windows | jq --arg title "$WINDOW_TITLE" '.[] | select(.app == "'$EDITOR_APP'" and (.title | contains($title))) | .id' 2>/dev/null)
                if [ -n "$WINDOW_ID" ]; then break; fi
            done
            
            if [ -n "$WINDOW_ID" ]; then
                echo "Window created. Configuring."
                yabai -m window "$WINDOW_ID" --toggle sticky --sub-layer normal
                yabai -m window "$WINDOW_ID" --resize abs:680:384
                yabai -m window "$WINDOW_ID" --move abs:1055:144
            else
                echo "Error: Could not create the Cursor scratchpad window."
                exit 1
            fi
        else
            # 确保窗口可见
            yabai -m window --deminimize "$WINDOW_ID"
        fi
        
        # 聚焦窗口
        yabai -m window "$WINDOW_ID" --focus
        sleep 0.2

        # 4. 将剪贴板内容粘贴到编辑器窗口
        osascript -e 'tell application "System Events" to tell process "'$EDITOR_APP'" to keystroke "a" using {command down}'
        sleep 0.1
        osascript -e 'tell application "System Events" to tell process "'$EDITOR_APP'" to keystroke "v" using {command down}'
    fi

# 模式二：普通切换显示/隐藏 (无参数)
else
    if [ -z "$TARGET_WINDOW" ]; then
        # --- 窗口不存在：初始化并开启 ---
        echo "Cursor scratchpad window not found. Initializing..."
        $EDITOR_COMMAND "$SCRATCHPAD_DIR" &
        for i in {1..20}; do
            sleep 0.25
            WINDOW_ID=$(yabai -m query --windows | jq --arg title "$WINDOW_TITLE" '.[] | select(.app == "'$EDITOR_APP'" and (.title | contains($title))) | .id' 2>/dev/null)
            if [ -n "$WINDOW_ID" ]; then break; fi
        done

        if [ -n "$WINDOW_ID" ]; then
            echo "Window found with ID: $WINDOW_ID. Configuring and focusing."
            yabai -m window "$WINDOW_ID" --toggle sticky --sub-layer normal
            yabai -m window "$WINDOW_ID" --resize abs:680:384
            yabai -m window "$WINDOW_ID" --move abs:1055:144
            yabai -m window "$WINDOW_ID" --focus
        else
            echo "Error: Could not find the Cursor scratchpad window after launching."
            exit 1
        fi
    else
        # --- 窗口已存在：切换显示/隐藏 ---
        IS_VISIBLE=$(echo "$TARGET_WINDOW" | jq -r '."is-visible"')
        if [ "$IS_VISIBLE" = "true" ]; then
            yabai -m window "$WINDOW_ID" --minimize
        else
            yabai -m window --deminimize "$WINDOW_ID"
            yabai -m window "$WINDOW_ID" --focus
        fi
    fi
fi

