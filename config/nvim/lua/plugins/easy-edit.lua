return {
    {
        'jiangmiao/auto-pairs',
    },
    {
        'tpope/vim-surround',
    },
    {
        'terryma/vim-multiple-cursors',
    },
    {
        'easymotion/vim-easymotion',
    },
    {
        'andymass/vim-matchup',
        init = function()   
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
    },
}