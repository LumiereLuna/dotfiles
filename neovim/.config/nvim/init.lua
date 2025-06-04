local on_android_device = string.find(vim.uv.os_uname().release, 'android') and true or false

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.opt_global.expandtab = true
vim.opt_global.shiftwidth = 4
vim.opt_global.softtabstop = 4

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'
vim.o.scrolloff = 3
vim.o.confirm = true

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

-- ######## Install `lazy.nvim` plugin manager ########

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- ######## Configure and install plugins ########

require('lazy').setup({
    -- Detect tabstop and shiftwidth automatically
    'NMAC427/guess-indent.nvim',
    -- Useful plugin to show you pending keybinds.
    require 'custom.plugins.which-key',
        -- Fuzzy Finder (files, lsp, etc)
    not on_android_device and require 'custom.plugins.telescope' or {},
        -- Configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
    not on_android_device and require 'custom.plugins.lazydev' or {},
        -- Main LSP Configuration
    not on_android_device and require 'custom.plugins.nvim-lspconfig' or {},
        -- Autoformat
    not on_android_device and require 'custom.plugins.conform' or {},
        -- Autocompletion
    not on_android_device and require 'custom.plugins.blink' or {},
    -- Collection of various small independent plugins/modules
    require 'custom.plugins.mini',
    -- Highlight, edit, and navigate code
    require 'custom.plugins.nvim-treesitter',
    -- Add indentation guides even on blank lines
    require 'custom.plugins.indent-blankline',
        -- Linting
    not on_android_device and require 'custom.plugins.nvim-lint' or {},
    require 'custom.plugins.nvim-autopairs',
    require 'custom.plugins.catppuccin',
    not on_android_device and require 'custom.plugins.no-neck-pain' or {},
    require 'custom.plugins.trim',
}, {
    ui = {
        -- If you are using a Nerd Font: set icons to an empty table which will use the
        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})
