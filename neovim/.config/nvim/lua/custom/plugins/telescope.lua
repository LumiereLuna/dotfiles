return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable('make') == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
        require('telescope').setup({
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
            pickers = {
                find_files = {
                    cwd = '$HOME',
                },
                live_grep = {
                    cwd = '$HOME',
                },
            },
        })

        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- Returns project root dir or CWD if there isn't one.
        -- It returns $HOME if there's no CWD either.
        local find_project_root = function()
            return require('mini.misc').find_root() or vim.uv.cwd() or '$HOME'
        end

        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep({
                cwd = find_project_root(),
                additional_args = { '--hidden' },
                prompt_title = 'Live Grep in CWD',
            })
        end, { desc = '[S]earch [/] by grep in project dir.' })

        vim.keymap.set('n', '<leader>s.', function()
            builtin.find_files({
                cwd = find_project_root(),
                hidden = true,
                prompt_title = 'Find Project Files',
            })
        end, { desc = '[S]earch [.] project files' })
    end,
}
