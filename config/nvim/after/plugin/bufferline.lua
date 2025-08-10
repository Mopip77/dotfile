local ok, bufferline = pcall(require, "bufferline")
if not ok then
    return
end

bufferline.setup({
    options = {
        separator_style = "slant",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            if context.buffer:current() then
                return ''
            end
            return ''
        end,
        buffer_close_icon = '',
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true
            }
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = 'insert_after_current',
    }
})

vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer1<CR>")
vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer2<CR>")
vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer3<CR>")
vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer4<CR>")
vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer5<CR>")
vim.keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer6<CR>")
vim.keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer7<CR>")
vim.keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer8<CR>")
