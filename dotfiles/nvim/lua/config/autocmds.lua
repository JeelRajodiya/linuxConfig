-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    command = "FormatWriteLock",
})

-- Transparent bufferline — only strip bg, preserve fg and other attrs
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = function()
    vim.defer_fn(function()
      -- The fill area (empty space in the tabline)
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
      -- Strip bg from all BufferLine groups while keeping fg/bold/italic
      local all = vim.api.nvim_get_hl(0, {})
      for name, hl in pairs(all) do
        if name:match("^BufferLine") then
          hl.bg = nil
          hl.ctermbg = nil
          pcall(vim.api.nvim_set_hl, 0, name, hl)
        end
      end
    end, 200)
  end,
})

-- Auto-save when focus is lost or buffer is left
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    pattern = "*",
    command = "silent! wa",
})
