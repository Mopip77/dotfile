text=""
allow_fallback=false

# 解析参数
[[ "$1" == "--allow-clipboard-fallback" ]] && allow_fallback=true

# 1. 尝试通过 Accessibility API 获取选中文本 (不影响剪贴板)
if [[ -x "${HOME}/.config/my-scripts/lib/get-selected-text" ]]; then
    text=$("${HOME}/.config/my-scripts/lib/get-selected-text" 2>/dev/null)
fi

# 2. 如果没有选中文本且允许回退，使用剪贴板方式
if [[ -z "$text" && "$allow_fallback" == true ]]; then
    clipboard_backup=$(pbpaste 2>/dev/null)
    osascript -e 'tell application "System Events" to keystroke "c" using command down' 2>/dev/null
    sleep 0.05  # 快速获取，类似 PopClip
    text=$(pbpaste 2>/dev/null)
    # 恢复剪贴板（如果获取到了新内容）
    if [[ "$text" != "$clipboard_backup" ]]; then
        printf "%s" "$clipboard_backup" | pbcopy 2>/dev/null
    else
        text=""  # 没有选中新内容
    fi
fi

# 3. 如果还是没有选中文本，使用剪贴板
if [[ -z "$text" ]]; then
    text=$(pbpaste 2>/dev/null)
fi

# 4. 返回结果
echo "$text"