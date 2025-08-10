return {
    {
        'akinsho/bufferline.nvim',
        version = "v4.*",
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        cond = not vim.g.vscode,
    },
    {
        'shaunsingh/nord.nvim',
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        cond = not vim.g.vscode,
        lazy = true,
    },
}

