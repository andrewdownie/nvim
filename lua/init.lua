-- init.lua
--require('vgit').setup()

vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = true,
    position = 'right',
    relative_width = false,
    width = 25,
    auto_close = true,
    show_numbers = false,
    show_relative_numbers = true,
    show_symbol_details = false,
    preview_bg_highlight = 'Pmenu',
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        goto_location = "o",
        focus_location = "<Cr>",
    },
}

