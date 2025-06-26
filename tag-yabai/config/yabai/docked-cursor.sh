#!/bin/bash

# 确保 jq 已安装 (brew install jq)
WINDOW_TITLE=".docked-cursor"
SCRATCHPAD_DIR="$HOME/.docked-cursor"

EDITOR_COMMAND="code"
EDITOR_APP="Cursor"

# 查询目标窗口的信息
TARGET_WINDOW=$(yabai -m query --windows | jq --arg title "$WINDOW_TITLE" '.[] | select(.app == "'$EDITOR_APP'" and .title == $title)')

if [ -z "$TARGET_WINDOW" ]; then
    # --- 窗口不存在：初始化并开启 ---
    echo "Cursor scratchpad window not found. Initializing..."

    # 1. 确保目录存在
    if [ ! -d "$SCRATCHPAD_DIR" ]; then
        echo "Creating directory: $SCRATCHPAD_DIR"
        mkdir -p "$SCRATCHPAD_DIR"
    fi

    # 2. 启动 Cursor 打开该目录 (在后台运行)
    # 这将启动Cursor（如果它没在运行），或打开一个新窗口（如果已在运行）
    $EDITOR_COMMAND "$SCRATCHPAD_DIR" &

    # 3. 等待窗口出现并获取其ID
    # 我们会轮询几次来等待yabai识别到新窗口
    WINDOW_ID=""
    for i in {1..20}; do # 等待最多 5 秒 (20 * 0.25s)
        sleep 0.25
        # 2>/dev/null 用于抑制jq在找不到窗口时的错误输出
        WINDOW_ID=$(yabai -m query --windows | jq --arg title "$WINDOW_TITLE" '.[] | select(.app == "'$EDITOR_APP'" and .title == $title) | .id' 2>/dev/null)
        if [ -n "$WINDOW_ID" ]; then
            break
        fi
    done

    # 4. 如果成功找到窗口，则配置并聚焦
    if [ -n "$WINDOW_ID" ]; then
        echo "Window found with ID: $WINDOW_ID. Configuring and focusing."
        # yabai -m window "$WINDOW_ID" --space recent  # 将窗口带到当前桌面
        # yabai -m window "$WINDOW_ID" --layer topmost # 设置为最顶层
        yabai -m window "$WINDOW_ID" --toggle sticky \
            && yabai -m window "$WINDOW_ID" --sub-layer normal

        # 指定窗口大小和位置
        yabai -m window "$WINDOW_ID" --resize abs:680:384
        yabai -m window "$WINDOW_ID" --move abs:1055:144


        yabai -m window "$WINDOW_ID" --focus        # 聚焦窗口
    else
        echo "Error: Could not find the Cursor scratchpad window after launching."
        exit 1
    fi
else
    # --- 窗口已存在：切换显示/隐藏 ---
    WINDOW_ID=$(echo $TARGET_WINDOW | jq -r '.id')
    IS_VISIBLE=$(echo $TARGET_WINDOW | jq -r '."is-visible"')

    if [ "$IS_VISIBLE" = "true" ]; then
        # 如果窗口在当前空间可见，则将其最小化
        yabai -m window "$WINDOW_ID" --minimize
    else
        # 取消最小化(会直接在当前空间显示)
        yabai -m window --deminimize "$WINDOW_ID"
    fi
fi

