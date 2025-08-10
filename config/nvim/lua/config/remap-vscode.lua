if vim.g.vscode then
    local map = vim.keymap.set
    local vscode = require('vscode')

    print("Mapping gd → Go to Implementation is being set")

    map("n", "gd", function()
        vscode.call("editor.action.goToImplementation")
    end, { noremap = true, silent = true })

end