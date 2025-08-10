-- Mason setup for LSP server management
local ok, mason = pcall(require, "mason")
if not ok then
    return
end

mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- Mason-lspconfig setup
local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok then
    return
end

mason_lspconfig.setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "ts_ls",
        "eslint",
    },
    automatic_installation = true,
})

-- LSP server configurations
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok then
    return
end

-- Create capabilities for autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Common on_attach function for all LSP servers
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- Disable eslint as requested in original config
    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end

    -- Key mappings (keeping the same as original)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

-- Configure individual LSP servers
local servers = {
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            }
        }
    },
    rust_analyzer = {},
    ts_ls = {},
    eslint = {},
}

-- Setup each server
for server, config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = on_attach,
    }, config))
end

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

-- Diagnostic signs
local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Autocompletion setup
local ok, cmp = pcall(require, "cmp")
if not ok then
    return
end

local ok, luasnip = pcall(require, "luasnip")
if not ok then
    return
end

-- Load friendly-snippets
local ok, luasnip_loaders = pcall(require, "luasnip.loaders.from_vscode")
if not ok then
    return
end
luasnip_loaders.lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lua" },
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lua = "[Lua]",
            })[entry.source.name]
            return vim_item
        end,
    },
})

-- Formatter setup with conform.nvim (with safe loading)
local conform_ok, conform = pcall(require, "conform")
if conform_ok then
    conform.setup({
        formatters_by_ft = {
            lua = { "stylua" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            markdown = { "prettier" },
            rust = { "rustfmt" },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
    })

    -- Format keymap (keeping the same as original)
    vim.keymap.set({ "n", "v" }, "gq", function()
        conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
        })
    end, { desc = "Format file or range (in visual mode)" })
else
    -- Fallback to LSP formatting if conform is not available
    vim.keymap.set({ "n", "v" }, "gq", function()
        vim.lsp.buf.format({ async = false })
    end, { desc = "Format file or range (in visual mode)" })
end

-- Setup nvim-lint for additional linting (with safe loading)
local lint_ok, lint = pcall(require, "lint")
if lint_ok then
    lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
    }

    -- Auto-command for linting
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
            lint.try_lint()
        end,
    })
end
