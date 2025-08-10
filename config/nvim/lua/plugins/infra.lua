return {
    {
        'ethanholz/nvim-lastplace',
    },
    {
        'preservim/nerdcommenter',
    },
    {
        'nvimdev/dashboard-nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        cond = not vim.g.vscode,
    },
}