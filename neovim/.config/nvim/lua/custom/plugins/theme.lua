return {
    'kungfusheep/mfd.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('mfd').setup({
            accessibility_contrast = 7,
        })
        vim.cmd.colorscheme('mfd-lumon')

        vim.opt.guicursor = {
            'n:block-CursorNormal',
            'v:block-CursorVisual',
            'i:block-CursorInsert',
            'r-cr:block-CursorReplace',
            'c:block-CursorCommand',
        }

        require('mfd').enable_cursor_sync()
    end,
}
