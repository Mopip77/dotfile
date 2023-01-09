vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- quick save and close
vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", "<leader>q", vim.cmd.q)
vim.keymap.set("n", "<leader>Q", "<cmd>q!<CR>")

-- winodw move
vim.keymap.set({"n", "v"}, "<C-h>", "<C-w>h")
vim.keymap.set({"n", "v"}, "<C-j>", "<C-w>j")
vim.keymap.set({"n", "v"}, "<C-k>", "<C-w>k")
vim.keymap.set({"n", "v"}, "<C-l>", "<C-w>l")

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
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- 快速增加可执行权限
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
