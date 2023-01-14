local db = require('dashboard')

db.header_pad = 3
db.center_pad = 3
db.footer_pad = 3

db.custom_footer = { '> 不要温和地走进那个良夜 <' }

db.custom_center = {
    { icon_hl = { fg = '#1F8176' }, icon = '', desc = ' New File    ', action = 'DashboardNewFile', shortcut = "      Enter" },
    { icon_hl = { fg = '#1F8176' }, icon = '', desc = ' Find File   ', action = 'Telescope find_files', shortcut = "     Ctrl P" },
    { icon_hl = { fg = '#1F8176' }, icon = '', desc = ' Recent Files', action = 'Telescope oldfiles', shortcut = "      SPC e" },
    { icon_hl = { fg = '#1F8176' }, icon = '', desc = ' Search Text ', action = 'Telescope live_grep', shortcut = "    SPC p s" },
}

db.custom_header = {
    '          ▀████▀▄▄              ▄█ ',
    '            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ',
    '    ▄        █          ▀▀▀▀▄  ▄▀  ',
    '   ▄▀ ▀▄      ▀▄              ▀▄▀  ',
    '  ▄▀    █     █▀   ▄█▀▄      ▄█    ',
    '  ▀▄     ▀▄  █     ▀██▀     ██▄█   ',
    '   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ',
    '    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ',
    '   █   █  █      ▄▄           ▄▀   ',
}

vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#B5AA99" })
vim.api.nvim_set_hl(0, "DashboardCenter", { fg = "#FFEECB" })
vim.api.nvim_set_hl(0, "DashboardShortCut", { fg = "#994DA4" })
vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#EABA57", bold = true, italic = true })
