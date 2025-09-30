return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Allows extra capabilities provided by blink.cmp
        'saghen/blink.cmp',
    },
    config = function()
        --  This function gets run when an LSP attaches to a particular buffer.
        --  That is to say, every time a new file is opened that is associated with
        --  an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --  function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
                map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
                map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
                map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
            end,
        })

        -- Diagnostic Config
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN] = '󰀪 ',
                    [vim.diagnostic.severity.INFO] = '󰋽 ',
                    [vim.diagnostic.severity.HINT] = '󰌶 ',
                },
            } or {},
            virtual_text = {
                source = 'if_many',
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        vim.lsp.config('lua_ls', {
            -- cmd = { 'lua-language-server' },
            -- filetypes = { 'lua' },
            -- root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
            settings = {
                Lua = {
                    completion = {
                        callSnippet = 'Replace',
                    },
                    diagnostics = { disable = { 'missing-fields' } },
                },
            },
            capabilities = capabilities,
        })
        vim.lsp.enable('lua_ls')
    end,
}
