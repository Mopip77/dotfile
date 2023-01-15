require("nvim-tree").setup({
    view = {
        mappings = {
            list = {
                { key = "<Tab>", action = "cd" },
                { key = "<S-Tab>", action = "dir_up" },
            },
        },
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true
    },
    filters = {
        custom = { '^.git$', '^node_modules$' }
    },
    git = {
        enable = false
    }
})

function G_nvim_tree_replace_current_buffer()
    return function ()
        local previous_buf = vim.api.nvim_get_current_buf()
        require("nvim-tree").open_replacing_current_buffer()
        require("nvim-tree.api").tree.find_file(previous_buf)
    end
end

vim.keymap.set("n", "<leader>n", vim.cmd.NvimTreeToggle)
-- 全屏打开
vim.keymap.set("n", "<leader>pv", G_nvim_tree_replace_current_buffer())
