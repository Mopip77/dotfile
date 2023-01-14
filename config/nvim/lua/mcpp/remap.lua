vim.keymap.set("n", "<leader>l", vim.cmd.noh)

-- quick save and close
vim.keymap.set("n", "<leader>s", vim.cmd.w)
vim.keymap.set("n", "<leader>q", vim.cmd.q)
vim.keymap.set("n", "<leader>Q", "<cmd>q!<CR>")

-- winodw move
vim.keymap.set({"n", "v"}, "<C-h>", "<C-w>h")
vim.keymap.set({"n", "v"}, "<C-j>", "<C-w>j")
vim.keymap.set({"n", "v"}, "<C-k>", "<C-w>k")
vim.keymap.set({"n", "v"}, "<C-l>", "<C-w>l")

-- buffer
vim.keymap.set("n", "<tab>", vim.cmd.bn)
vim.keymap.set("n", "<S-tab>", vim.cmd.bp)
vim.keymap.set("n", "<leader><tab>", vim.cmd.bdelete)
vim.keymap.set("n", "<leader><S-tab>", "<cmd>:bdelete!<CR>")

-- visual模式上下移动选中块
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- 将下一行移动到本行末尾
vim.keymap.set("n", "J", "mzJ`z")

-- 翻页和搜索时保持光标在屏幕中间
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- 一些删除操作不会进入buffer
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
vim.keymap.set({"n", "v"}, "x", [["_x]])
vim.keymap.set({"n", "v"}, "X", [["_X]])

-- 复制进入剪贴板
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

-- 快速替换当前word的snippet
vim.keymap.set("n", "<leader>c", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- 快速增加可执行权限
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- 在普通模式下使用<leader> /? 忽略大小写查找
vim.keymap.set("n", "<leader>/", [[/\c]])
vim.keymap.set("n", "<leader>?", [[?\c]])
-- 在visual模式下使用leader /? 快速查找选中内容
vim.api.nvim_exec(
  [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap <leader>/ :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap <leader>? :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]],
  false
)
