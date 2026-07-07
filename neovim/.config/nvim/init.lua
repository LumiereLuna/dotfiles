-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

local on_android_device = string.find(vim.uv.os_uname().release, 'android') and true or false
vim.g.have_nerd_font = not on_android_device and (os.getenv('TERM') == 'xterm-ghostty') or false

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.winborder = 'rounded'

vim.o.mouse = 'a'
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'
vim.o.confirm = true
vim.o.autochdir = true

vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    virtual_text = true, -- Text shows up at the end of the line

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float({
                bufnr = bufnr,
                scope = 'cursor',
                focus = false,
            })
        end,
    },

    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
    } or {},
})

-- ######## Keymaps ########

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- ######## Kickstart's vim.pack helper functions #########

local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
        local stderr = result.stderr or ''
        local stdout = result.stdout or ''
        local output = stderr ~= '' and stderr or stdout
        if output == '' then
            output = 'No output from build command.'
        end
        vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
end

-- This autocommand runs after a plugin is installed or updated and
--  runs the appropriate build command for that plugin if necessary.
--
-- See `:help vim.pack-events`
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind
        if kind ~= 'install' and kind ~= 'update' then
            return
        end

        if name == 'telescope-fzf-native.nvim' and vim.fn.executable('make') == 1 then
            run_build(name, { 'make' }, ev.data.path)
            return
        end

        if name == 'LuaSnip' then
            if vim.fn.has('win32') ~= 1 and vim.fn.executable('make') == 1 then
                run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
            end
            return
        end

        if name == 'nvim-treesitter' then
            if not ev.data.active then
                vim.cmd.packadd('nvim-treesitter')
            end
            vim.cmd('TSUpdate')
            return
        end
    end,
})

local function gh(repo)
    return 'https://github.com/' .. repo
end

-- ######## Configure and install plugins ########

-- "Blazing fast indentation style detection for Neovim written in Lua."
vim.pack.add({ gh('NMAC427/guess-indent.nvim') })
require('guess-indent').setup({})

-- "WhichKey helps you remember your Neovim keymaps, by showing available
-- keybindings in a popup as you type."
vim.pack.add({ gh('folke/which-key.nvim') })
require('which-key').setup({
    delay = 0,
    icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
            Up = '<Up> ',
            Down = '<Down> ',
            Left = '<Left> ',
            Right = '<Right> ',
            C = '<C-…> ',
            M = '<M-…> ',
            D = '<D-…> ',
            S = '<S-…> ',
            CR = '<CR> ',
            Esc = '<Esc> ',
            ScrollWheelDown = '<ScrollWheelDown> ',
            ScrollWheelUp = '<ScrollWheelUp> ',
            NL = '<NL> ',
            BS = '<BS> ',
            Space = '<Space> ',
            Tab = '<Tab> ',
            F1 = '<F1>',
            F2 = '<F2>',
            F3 = '<F3>',
            F4 = '<F4>',
            F5 = '<F5>',
            F6 = '<F6>',
            F7 = '<F7>',
            F8 = '<F8>',
            F9 = '<F9>',
            F10 = '<F10>',
            F11 = '<F11>',
            F12 = '<F12>',
        },
    },
    spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    },
})

-- "Library of 40+ independent Lua modules improving overall Neovim [...]
-- experience with minimal effort."
do
    vim.pack.add({ gh('echasnovski/mini.nvim') })
    require('mini.ai').setup({ n_lines = 500 })
    require('mini.surround').setup()

    local statusline = require('mini.statusline')
    statusline.setup({ use_icons = vim.g.have_nerd_font })
    statusline.section_location = function()
        return '%2l:%-2v'
    end

    require('mini.diff').setup({ view = { style = 'sign', signs = { add = '+', change = '~', delete = '-' } } })
    require('mini.notify').setup()

    local minifiles_opts = {
        windows = { max_number = 3 },
    }
    if not vim.g.have_nerd_font then
        minifiles_opts.content = { prefix = function() end }
    end
    require('mini.files').setup(minifiles_opts)
    vim.keymap.set('n', '<leader>o', function()
        -- Start always at parent dir of current file.
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    end, { desc = '[O]pen files' })

    require('mini.misc').setup()
end

-- "[A] highly extendable fuzzy finder over lists."
-- plenary.nvim: "All the lua functions I don't want to write twice."
-- telescope-fzf-native.nvim: "fzf-native is a c port of fzf. It only covers
-- the algorithm and implements few functions to support calculating the
-- score."
-- telescope-ui-select.nvim: "It sets vim.ui.select to telescope. That means
-- for example that neovim core stuff can fill the telescope picker. Example
-- would be lua vim.lsp.buf.code_action()."
do
    local telescope_plugins = {
        gh('nvim-lua/plenary.nvim'),
        gh('nvim-telescope/telescope.nvim'),
        gh('nvim-telescope/telescope-ui-select.nvim'),
    }
    if vim.fn.executable('make') == 1 then
        table.insert(telescope_plugins, gh('nvim-telescope/telescope-fzf-native.nvim'))
    end
    vim.pack.add(telescope_plugins)
    require('telescope').setup({
        extensions = {
            ['ui-select'] = {
                require('telescope.themes').get_dropdown(),
            },
        },
        pickers = {
            find_files = {
                file_ignore_patterns = { '%.git/' },
                cwd = '$HOME',
            },
            live_grep = {
                file_ignore_patterns = { '%.git/' },
                cwd = '$HOME',
            },
            buffers = {
                sort_lastused = true,
                sort_mru = true,
            },
        },
    })

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require('telescope.builtin')

    -- Returns project root dir or CWD if there isn't one.
    -- It returns $HOME if there's no CWD either.
    local find_project_root = function()
        return require('mini.misc').find_root(0, { '.git', 'Makfile', '.project' }) or vim.uv.cwd() or '$HOME'
    end

    vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files({
            cwd = find_project_root(),
            hidden = true,
            prompt_title = 'Find Project Files',
        })
    end, { desc = '[S]earch project [F]iles' })

    vim.keymap.set('n', '<leader>sg', function()
        builtin.live_grep({
            cwd = find_project_root(),
            additional_args = { '--hidden' },
            prompt_title = 'Live Grep in Project',
        })
    end, { desc = '[S]earch by [G]rep in project' })

    vim.keymap.set('n', '<leader>s<A-f>', function()
        builtin.find_files({
            hidden = true,
            prompt_title = 'Find All Files',
        })
    end, { desc = '[S]earch all [A-f]iles' })

    vim.keymap.set('n', '<leader>s<A-g>', function()
        builtin.find_files({
            additional_args = { '--hidden' },
            prompt_title = 'Live Grep All',
        })
    end, { desc = '[S]earch all by [A-g]rep' })

    vim.keymap.set('n', '<leader>sF', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sG', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })

    vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
            winblend = 10,
            previewer = false,
        }))
    end, { desc = '[/] Fuzzily search in current buffer' })
end

-- "[A]dds indentation guides to Neovim."
vim.pack.add({ gh('lukas-reineke/indent-blankline.nvim') })
require('ibl').setup({ indent = { char = '╎' } })

-- "A super powerful autopair plugin for Neovim that supports multiple
-- characters."
vim.pack.add({ gh('windwp/nvim-autopairs') })
require('nvim-autopairs').setup()

-- "[T]rims trailing whitespace and lines."
vim.pack.add({ gh('cappyzawa/trim.nvim') })
require('trim').setup()

vim.pack.add({ 'file:///home/selene/repos/kuromi.nvim' })
vim.cmd('colorscheme kuromi')

if not on_android_device then
    -- "[A] plugin that properly configures LuaLS for editing your Neovim
    -- config by lazily updating your workspace libraries."
    vim.pack.add({ gh('folke/lazydev.nvim') })
    require('lazydev').setup({
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
    })

    -- "Snippet Engine for Neovim written in Lua."
    vim.pack.add({ { src = gh('L3MON4D3/LuaSnip'), version = vim.version.range('2.*') } })
    require('luasnip').setup({})

    -- "Set of preconfigured snippets for different languages."
    vim.pack.add({ gh('rafamadriz/friendly-snippets') })
    require('luasnip.loaders.from_vscode').lazy_load()

    -- "Performant, batteries-included completion plugin for Neovim"
    -- Dependencies:
    vim.pack.add({ { src = gh('saghen/blink.cmp'), version = vim.version.range('1.*') } })
    require('blink.cmp').setup({
        keymap = {
            preset = 'default',
        },
        appearance = {
            nerd_font_variant = 'mono',
        },
        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 2000 },
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'lazydev' },
            providers = {
                lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
            },
        },
        snippets = { preset = 'luasnip' },
        fuzzy = { implementation = 'lua' },
        signature = { enabled = true },
        cmdline = { completion = { menu = { auto_show = true } } },
    })

    -- "[A] "data only" repo, providing basic, default Nvim LSP client
    -- configurations for various LSP servers. View all configs or :help
    -- lspconfig-all from Nvim."
    do
        vim.pack.add({ gh('neovim/nvim-lspconfig') })
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

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        vim.lsp.config('lua_ls', {
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
        vim.lsp.enable('pyright')
    end

    -- "Lightweight yet powerful formatter plugin for Neovim"
    do
        vim.pack.add({ gh('stevearc/conform.nvim') })
        require('conform').setup({
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                json = { 'jq' },
                html = { 'prettier' },
                javascript = { 'prettier' },
                python = { 'ruff_format' },
            },
        })
        vim.keymap.set('n', '<leader>f', function()
            require('conform').format({ async = true, lsp_format = 'fallback' })
        end, { desc = '[F]ormat buffer' })

        -- "An asynchronous linter plugin for Neovim complementary to the
        -- built-in Language Server Protocol support."
        vim.pack.add({ gh('mfussenegger/nvim-lint') })
        local lint = require('lint')
        -- This way of setting linters_by_ft allows other plugins to add linters
        -- to require('lint').linters_by_ft.
        lint.linters_by_ft = lint.linters_by_ft or {}

        -- Disable the default linters.
        lint.linters_by_ft['clojure'] = nil
        lint.linters_by_ft['dockerfile'] = nil
        lint.linters_by_ft['inko'] = nil
        lint.linters_by_ft['janet'] = nil
        lint.linters_by_ft['json'] = nil
        lint.linters_by_ft['markdown'] = nil
        lint.linters_by_ft['rst'] = nil
        lint.linters_by_ft['ruby'] = nil
        lint.linters_by_ft['terraform'] = nil
        lint.linters_by_ft['text'] = nil

        -- Create autocommand which carries out the actual linting
        -- on the specified events.
        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
            group = lint_augroup,
            callback = function()
                -- Only run the linter in buffers that you can modify in order to
                -- avoid superfluous noise, notably within the handy LSP pop-ups that
                -- describe the hovered symbol using Markdown.
                if vim.bo.modifiable then
                    lint.try_lint()
                end
            end,
        })
    end

    vim.pack.add({ gh('norcalli/nvim-colorizer.lua') })
    require('colorizer').setup({
        DEFAULT_OPTIONS = {
            names = false,
            RRGGBBAA = true,
        },
        'javascript',
        css = {
            css = true,
        },
    })
end
