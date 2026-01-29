#!/bin/bash

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin"

# 获取文本内容
text=$(~/.config/my-scripts/utils/get_prefer_text.sh --allow-clipboard-fallback)

# 保存选中内容到临时文件
TEMP_FILE="/tmp/claude-context-$(date +%s).txt"
echo "$text" > "$TEMP_FILE"

# 清理超过1天的旧临时文件
find /tmp -name "claude-context-*.txt" -mtime +1 -delete 2>/dev/null

echo "🚀 正在打开 Claude Code..."
toast-cli --position B --time 1 "使用 Claude Code✨ 打开" --icon ~/.config/my-scripts/assets/claude-color.svg &

if [[ -n "$text" ]]; then
    echo "📝 Prompt: ${text:0:100}$([ ${#text} -gt 100 ] && echo '...')"
else
    echo "ℹ️  无内容"
fi

# 从环境变量读取延迟时间，默认 2.5 秒
DELAY_TIME=${CLAUDE_DELAY_TIME:-2.5}

# 使用 AppleScript 创建新的 iTerm2 窗口并执行命令
/usr/bin/osascript <<APPLESCRIPT
tell application "iTerm"
    -- 使用 claude profile 创建新窗口
    set newWindow to (create window with profile "claude")

    -- 在新窗口中执行命令
    tell current session of newWindow
        -- 先查看文件内容
        write text "cat ${TEMP_FILE}"
        delay 0.5
        -- 然后执行 claude code 命令
        write text "claude code"
        delay ${DELAY_TIME}
        write text "@${TEMP_FILE}"
    end tell
end tell
APPLESCRIPT

if [ $? -ne 0 ]; then
    echo "❌ 错误: AppleScript 执行失败"
    exit 1
fi

echo "✅ Claude Code 已启动"
