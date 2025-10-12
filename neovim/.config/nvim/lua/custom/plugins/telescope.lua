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
        vim.keymap.set('n', '<leader><leader>', function()
            builtin.buffers({ sort_lastused = true, sort_mru = true })
        end, { desc = '[ ] Find existing buffers' })
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
    end,
}
