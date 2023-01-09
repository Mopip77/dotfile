require("bufferline").setup{
    options = {
        separator_style = "slant",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            if context.buffer:current() then
                return ''
            end

            return ''
        end
    }
}
