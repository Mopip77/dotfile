return {
    {
        'neovim/nvim-lspconfig',
        cond = not vim.g.vscode,
    },
    {
        'williamboman/mason.nvim',
        cond = not vim.g.vscode,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        cond = not vim.g.vscode,
    },
}