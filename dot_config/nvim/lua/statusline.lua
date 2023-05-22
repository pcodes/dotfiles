require('lualine').setup({
    options = {
        theme = 'tokyonight'
    },
    sections = {
       lualine_x = {
           {
           require("lazy.status").updates,
           cond=require("lazy.status").has_updates,
           color={fg="#ff9e64"},
       },
       },
    },
})


require('bufferline').setup {
options = {
    numbers = "buffer_id",
    indicator = {
	style = 'icon',
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    --- name_formatter can be d to change the buffer's label in the bufferline.
    --- Please note some names can/will break the
    --- bufferline so  this at your discretion knowing that it has
    --- some limitations that will *NOT* be fixed.
	  -- name                | str        | the basename of the active file
	  -- path                | str        | the full path of the active file
	  -- bufnr (buffer only) | int        | the number of the active buffer
	  -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
	  -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
    color_icons = true, -- whether or not to add the filetype icon highlights
    show_buffer_icons = true, -- disable filetype icons for buffers
    show_buffer_close_icons = true,
    show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focd and unfocused]. eg: { '|', '|' }
    separator_style = {"\u{e0b8}", "\u{e0ba}"},
    always_show_bufferline = true,
    hover = {
	enabled = true,
	delay = 200,
	reveal = {'close'}
    },
}
}
