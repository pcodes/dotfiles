-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Toggle markdown task-list checkboxes, `- [ ]` <-> `- [x]`, on the current
-- line or on every line of a visual selection. Lines without a box are left alone.
local function toggle_checkboxes(first, last)
  for lnum = first, last do
    local line = vim.fn.getline(lnum)
    local prefix = line:match("^%s*[-*+] ") or line:match("^%s*%d+[.)] ")
    if prefix then
      local box = line:sub(#prefix + 1, #prefix + 3)
      local rest = line:sub(#prefix + 4)
      if box == "[ ]" then
        vim.fn.setline(lnum, prefix .. "[x]" .. rest)
      elseif box == "[x]" or box == "[X]" then
        vim.fn.setline(lnum, prefix .. "[ ]" .. rest)
      end
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_checkbox", { clear = true }),
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>cx", function()
      local lnum = vim.fn.line(".")
      toggle_checkboxes(lnum, lnum)
    end, { buffer = ev.buf, desc = "Toggle Checkbox" })
    vim.keymap.set("x", "<leader>cx", function()
      local first, last = vim.fn.line("v"), vim.fn.line(".")
      if first > last then
        first, last = last, first
      end
      toggle_checkboxes(first, last)
      vim.cmd("normal! " .. vim.keycode("<Esc>"))
    end, { buffer = ev.buf, desc = "Toggle Checkboxes" })
  end,
})
