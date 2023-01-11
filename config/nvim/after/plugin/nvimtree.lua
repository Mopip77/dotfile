require("nvim-tree").setup({
    view = {
        mappings = {
            list = {
                { key = "<Tab>", action = "cd" },
                { key = "<S-Tab>", action = "dir_up" },
            },
        },
    }
})

function G_nvim_tree_replace_current_buffer()
    return function ()
        local previous_buf = vim.api.nvim_get_current_buf()
        require("nvim-tree").open_replacing_current_buffer()
        require("nvim-tree.api").tree.find_file(previous_buf)
    end
end

-- 打开当前文件所在文件夹
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle %:p:h<CR>")
-- 打开命令行所在文件夹
vim.keymap.set("n", "<leader>N", vim.cmd.NvimTreeToggle)
-- 关闭当前文件，打开nvimtree
vim.keymap.set("n", "<leader>pv", G_nvim_tree_replace_current_buffer())

