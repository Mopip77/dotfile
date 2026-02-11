#!/bin/bash

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:/opt/homebrew/Caskroom/miniconda/base/bin"

gemini_base_url=${GEMINI_BASE_URL:-"https://gemini.google.com/app"}
prompt_port=18232

# 检测剪贴板是否包含图片
has_clipboard_image=$(osascript -e 'clipboard info' 2>/dev/null | grep -c 'PNGf')

if [[ "$has_clipboard_image" -gt 0 ]]; then
    # 图片流程：保存剪贴板图片到临时文件，启动 HTTP server 返回 image/png
    tmp_image="/tmp/clipboard_image_$$.png"
    osascript -e "
        set imgData to the clipboard as «class PNGf»
        set filePath to POSIX file \"${tmp_image}\"
        set fileRef to open for access filePath with write permission
        write imgData to fileRef
        close access fileRef
    "

    python3 -c "
import http.server, socketserver, sys, os
img_path = '${tmp_image}'
with open(img_path, 'rb') as f:
    data = f.read()
os.unlink(img_path)
socketserver.TCPServer.allow_reuse_address = True
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type','image/png')
        self.send_header('Access-Control-Allow-Origin','*')
        self.end_headers()
        self.wfile.write(data)
    def log_message(self, *a): pass
with socketserver.TCPServer(('127.0.0.1', ${prompt_port}), H) as s:
    s.handle_request()
" &
    url="${gemini_base_url}?port=${prompt_port}"

    echo "🚀 正在打开 Gemini..."
    toast-cli --position B --time 1 "使用 Gemini✨ 打开图片" --icon ~/.config/my-scripts/assets/gemini-color.svg &
    echo "🖼️  Prompt: [剪贴板图片]"
else
    # 文本流程
    text=$(~/.config/my-scripts/utils/get_prefer_text.sh --allow-clipboard-fallback)

    # URL 编码后长度阈值（超过则用 HTTP 服务传递，避免中文乱码）
    max_url_encoded_len=1500

    encoded_text=$(python3 -c "import sys,urllib.parse; print(urllib.parse.quote(sys.stdin.buffer.read().decode()))" <<< "$text")

    if [[ ${#encoded_text} -le $max_url_encoded_len ]]; then
        # 短文本：直接 URL 参数传递，速度快
        url="${gemini_base_url}?prompt=${encoded_text}"
    else
        # 长文本：启动一次性 HTTP 服务传递，避免 URL 截断导致乱码
        python3 -c "
import http.server, socketserver, sys
text = sys.stdin.buffer.read()
socketserver.TCPServer.allow_reuse_address = True
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type','text/plain; charset=utf-8')
        self.send_header('Access-Control-Allow-Origin','*')
        self.end_headers()
        self.wfile.write(text)
    def log_message(self, *a): pass
with socketserver.TCPServer(('127.0.0.1', ${prompt_port}), H) as s:
    s.handle_request()
" <<< "$text" &
        url="${gemini_base_url}?port=${prompt_port}"
    fi

    echo "🚀 正在打开 Gemini..."
    toast-cli --position B --time 1 "使用 Gemini✨ 打开" --icon ~/.config/my-scripts/assets/gemini-color.svg &

    if [[ -n "$text" ]]; then
        echo "📝 Prompt: ${text:0:100}$([ ${#text} -gt 100 ] && echo '...')"
    else
        echo "ℹ️  无内容"
    fi
fi

# 打开浏览器
open "$url"
