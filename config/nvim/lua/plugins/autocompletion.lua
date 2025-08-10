return {
    {
        'hrsh7th/nvim-cmp',
        cond = not vim.g.vscode,
    },
    {
        'hrsh7th/cmp-buffer',
        cond = not vim.g.vscode,
    },
    {
        'hrsh7th/cmp-path',
        cond = not vim.g.vscode,
    },
    {
        'saadparwaiz1/cmp_luasnip',
        cond = not vim.g.vscode,
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        cond = not vim.g.vscode,
    },
    {
        'hrsh7th/cmp-nvim-lua',
        cond = not vim.g.vscode,
    },
}