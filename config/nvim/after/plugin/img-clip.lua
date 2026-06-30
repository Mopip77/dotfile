local ok, img_clip = pcall(require, "img-clip")
if not ok then
    return
end

img_clip.setup({})

vim.keymap.set("n", "<leader>i", "<cmd>PasteImage<cr>", { desc = "Paste image from clipboard" })
