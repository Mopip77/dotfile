gemini_base_url=${GEMINI_BASE_URL:-"https://gemini.google.com/app"}
text=$(~/.config/my-scripts/utils/get_prefer_text.sh --allow-clipboard-fallback)

# URL 编码 prompt 参数
encoded_text=$(python3 -c "import sys; from urllib.parse import quote; print(quote(sys.argv[1]))" "$text" 2>/dev/null)

# 如果 python3 不可用，使用 perl 作为备选
if [[ -z "$encoded_text" ]]; then
    encoded_text=$(perl -MURI::Escape -e "print uri_escape('$text');" 2>/dev/null)
fi

# 构建完整 URL
url="${gemini_base_url}?prompt=${encoded_text}"

echo "🚀 正在打开 Gemini..."
toast-cli --position B --time 1 "使用 Gemini✨ 打开" &

if [[ -n "$text" ]]; then
    echo "📝 Prompt: ${text:0:100}$([ ${#text} -gt 100 ] && echo '...')"
else
    echo "ℹ️  无内容"
fi

# 打开浏览器
open "$url"
