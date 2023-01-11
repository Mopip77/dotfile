-- 简化提示
vim.g.EasyMotion_prompt = '{n}> '

vim.keymap.set('n', '<leader><leader>l', '<Plug>(easymotion-lineforward)', {noremap = false, silent = true})
vim.keymap.set('n', '<leader><leader>h', '<Plug>(easymotion-linebackward)', {noremap = false, silent = true})
-- 使用双向查找（否则只会查找光标下方的行）
vim.keymap.set('n', '<leader><leader>w', '<Plug>(easymotion-bd-w)', {noremap = false, silent = true})
vim.keymap.set('n', '<leader><leader>W', '<Plug>(easymotion-bd-W)', {noremap = false, silent = true})
vim.keymap.set('n', '<leader><leader>e', '<Plug>(easymotion-bd-e)', {noremap = false, silent = true})
vim.keymap.set('n', '<leader><leader>E', '<Plug>(easymotion-bd-E)', {noremap = false, silent = true})
vim.keymap.set('n', '<leader><leader>f', '<Plug>(easymotion-bd-f)', {noremap = false, silent = true})

vim.keymap.set({ 'n' , 'v' }, '<leader><leader>/', '<Plug>(easymotion-sn)', {noremap = false, silent = true})
