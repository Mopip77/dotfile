return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        cond = not vim.g.vscode,
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        cond = not vim.g.vscode,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        cond = not vim.g.vscode,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        cond = not vim.g.vscode,
    },
    {
        'mbbill/undotree',
        cond = not vim.g.vscode,
    },    
}