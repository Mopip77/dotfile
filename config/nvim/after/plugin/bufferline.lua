require("bufferline").setup{
    options = {
        separator_style = "slant",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            if context.buffer:current() then
                return ''
            end

            return ''
        end,
        buffer_close_icon = '',
    }
}

vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer1<CR>")
vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer2<CR>")
vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer3<CR>")
vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer4<CR>")
vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer5<CR>")
vim.keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer6<CR>")
vim.keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer7<CR>")
vim.keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer8<CR>")
