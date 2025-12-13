#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const https = require('https');

// 检查命令行参数
if (process.argv.length < 4) {
  console.error('用法: node md-convert.js <input.md> <output.html>');
  process.exit(1);
}

const inputFile = process.argv[2];
const outputFile = process.argv[3];

// 读取 Markdown 文件
const markdown = fs.readFileSync(inputFile, 'utf-8');

// 下载并缓存资源
async function downloadResource(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    }).on('error', reject);
  });
}

async function generateHTML() {
  console.log('正在下载必要的资源...');

  // 下载依赖
  const [markedJS, mermaidJS, githubCSS] = await Promise.all([
    downloadResource('https://cdn.jsdelivr.net/npm/marked@11.1.1/marked.min.js'),
    downloadResource('https://cdn.jsdelivr.net/npm/mermaid@10.6.1/dist/mermaid.min.js'),
    downloadResource('https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.0/github-markdown.min.css')
  ]);

  console.log('资源下载完成，正在生成 HTML...');

  // 生成完整的 HTML
  const html = `<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${path.basename(inputFile, '.md')}</title>
  <style>
${githubCSS}

/* 自定义样式 */
.markdown-body {
  box-sizing: border-box;
  min-width: 200px;
  max-width: 980px;
  margin: 0 auto;
  padding: 45px;
}

@media (max-width: 767px) {
  .markdown-body {
    padding: 15px;
  }
}

/* Mermaid 图表样式优化 */
.mermaid {
  text-align: center;
  margin: 20px 0;
}

/* 打印样式 */
@media print {
  .markdown-body {
    padding: 20px;
  }
}
  </style>
</head>
<body>
  <article class="markdown-body">
    <div id="content"></div>
  </article>

  <script>
${markedJS}
  </script>

  <script>
${mermaidJS}
  </script>

  <script>
    // Markdown 内容
    const markdownContent = ${JSON.stringify(markdown)};

    // 配置 Marked 解析 Mermaid 代码块
    const renderer = new marked.Renderer();
    const originalCodeRenderer = renderer.code.bind(renderer);

    renderer.code = function(code, language) {
      if (language === 'mermaid') {
        return '<pre class="mermaid">' + code + '</pre>';
      }
      return originalCodeRenderer(code, language);
    };

    marked.setOptions({
      renderer: renderer,
      highlight: null,
      gfm: true,
      breaks: true
    });

    // 渲染 Markdown
    document.getElementById('content').innerHTML = marked.parse(markdownContent);

    // 初始化 Mermaid
    mermaid.initialize({
      startOnLoad: true,
      theme: 'default',
      securityLevel: 'loose'
    });
  </script>
</body>
</html>`;

  fs.writeFileSync(outputFile, html);
  console.log(`✓ 转换完成: ${outputFile}`);
  console.log(`✓ 文件大小: ${(fs.statSync(outputFile).size / 1024).toFixed(2)} KB`);
}

generateHTML().catch(err => {
  console.error('转换失败:', err.message);
  process.exit(1);
});
