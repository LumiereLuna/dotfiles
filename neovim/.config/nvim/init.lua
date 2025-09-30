local on_android_device = string.find(vim.uv.os_uname().release, 'android') and true or false
vim.g.have_nerd_font = not on_android_device and true or false

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.textwidth = 80

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'
vim.o.scrolloff = 3
vim.o.confirm = true
vim.o.autochdir = true

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

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- ######## Configure and install plugins ########

local plugins = {
    -- "Blazing fast indentation style detection for Neovim written in Lua."
    require('custom.plugins.guess-indent'),
    -- "WhichKey helps you remember your Neovim keymaps, by showing available
    -- keybindings in a popup as you type."
    require('custom.plugins.which-key'),
    -- "Library of 40+ independent Lua modules improving overall Neovim [...]
    -- experience with minimal effort."
    require('custom.plugins.mini'),
    -- "[A] highly extendable fuzzy finder over lists."
    -- Dependencies:
    -- plenary.nvim: "All the lua functions I don't want to write twice."
    -- telescope-fzf-native.nvim: "fzf-native is a c port of fzf. It only covers
    -- the algorithm and implements few functions to support calculating the
    -- score."
    -- telescope-ui-select.nvim: "It sets vim.ui.select to telescope. That means
    -- for example that neovim core stuff can fill the telescope picker. Example
    -- would be lua vim.lsp.buf.code_action()."
    -- nvim-web-devicons: "Provides Nerd Font icons (glyphs) for use by neovim
    -- plugins"
    require('custom.plugins.telescope'),
    -- "The goal of nvim-treesitter is both to provide a simple and easy way to
    -- use the interface for tree-sitter in Neovim and to provide some basic
    -- functionality such as highlighting based on it[.]"
    require('custom.plugins.nvim-treesitter'),
    -- "[A]dds indentation guides to Neovim."
    require('custom.plugins.indent-blankline'),
    -- "A super powerful autopair plugin for Neovim that supports multiple
    -- characters."
    require('custom.plugins.nvim-autopairs'),
    -- "[T]rims trailing whitespace and lines."
    require('custom.plugins.trim'),
    -- "[A] community-driven pastel theme that aims to be the middle ground
    -- between low and high contrast themes."
    require('custom.plugins.catppuccin'),
}

if not on_android_device then
    vim.list_extend(plugins, {
        -- "[A] plugin that properly configures LuaLS for editing your Neovim
        -- config by lazily updating your workspace libraries."
        require('custom.plugins.lazydev'),
        -- "[A] "data only" repo, providing basic, default Nvim LSP client
        -- configurations for various LSP servers. View all configs or :help
        -- lspconfig-all from Nvim."
        -- Dependencies:
        -- blink.cmp: see below.
        require('custom.plugins.nvim-lspconfig'),
        -- "Lightweight yet powerful formatter plugin for Neovim"
        require('custom.plugins.conform'),
        -- "Performant, batteries-included completion plugin for Neovim"
        -- Dependencies:
        -- LuaSnip: "Snippet Engine for Neovim written in Lua."
        --   Dependencies:
        --   friendly-snippets: "Set of preconfigured snippets for
        --   different languages."
        -- lazydev: see above.
        require('custom.plugins.blink'),
        -- "An asynchronous linter plugin for Neovim complementary to the
        -- built-in Language Server Protocol support."
        require('custom.plugins.nvim-lint'),
        -- "Dead simple plugin to center the currently focused buffer to the
        -- middle of the screen."
        require('custom.plugins.no-neck-pain'),
    })
end

require('lazy').setup(plugins, {
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
