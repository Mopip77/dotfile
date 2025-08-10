local ok, db = pcall(require, 'dashboard')
if not ok then
    return
end

db.setup({
    theme = 'hyper',
    config = {
        week_header = {
            enable = true,
        },
        shortcut = {
            {
                icon = '',
                desc = ' New File',
                action = 'lua require("dashboard"):new_file()',
                key = 'n',
                keymap  = "Enter"
            },
            {
                icon = '',
                desc = ' Find File',
                action = 'Telescope find_files',
                key = 'f',
                keymap  = "Ctrl P"
            },
            {
                icon = '',
                desc = ' Recent Files',
                action = 'Telescope oldfiles',
                key = 'e',
                keymap = "SPC e"
            },
            {
                icon = '',
                desc = ' Search Text',
                action = 'Telescope live_grep',
                key = 'p',
                keymap  = "SPC p s"
            },
        },
    },
})
