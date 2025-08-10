local ok, notify = pcall(require, "notify")
if not ok then
    return
end

notify.setup({
    max_width = 80,
    minimum_width = 30,
    fps = 60,
})
