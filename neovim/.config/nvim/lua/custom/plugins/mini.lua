return {
    'echasnovski/mini.nvim',
    config = function()
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
            options = { permanent_delete = false },
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
        MiniMisc.setup_auto_root()
    end,
}
