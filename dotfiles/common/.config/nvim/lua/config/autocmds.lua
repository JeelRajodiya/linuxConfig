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
      -- Strip bg from BufferLine, Glance, and Noice groups while keeping fg/bold/italic
      local all = vim.api.nvim_get_hl(0, {})
      for name, hl in pairs(all) do
        if name:match("^BufferLine") or name:match("^Glance") or name:match("^Noice") then
          hl.bg = nil
          hl.ctermbg = nil
          pcall(vim.api.nvim_set_hl, 0, name, hl)
        end
      end

      -- Floating windows: semi-transparent dark bg so they stand out
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "LazyNormal", { bg = "#1e1e1e" })

      -- Transparent lualine/statusline
      for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
        if name:match("^lualine") or name:match("^StatusLine") then
          hl.bg = nil
          hl.ctermbg = nil
          -- Fix mode indicator text: use yellow for insert/visual mode labels
          if name:match("lualine_a_insert") then
            hl.fg = tonumber("e5c07b", 16)
            hl.bold = true
          elseif name:match("lualine_a_visual") then
            hl.fg = tonumber("c678dd", 16)
            hl.bold = true
          elseif name:match("lualine_a_command") then
            hl.fg = tonumber("98c379", 16)
            hl.bold = true
          elseif name:match("lualine_a_normal") then
            hl.fg = tonumber("61afef", 16)
            hl.bold = true
          elseif name:match("lualine_a_replace") then
            hl.fg = tonumber("e06c75", 16)
            hl.bold = true
          end
          pcall(vim.api.nvim_set_hl, 0, name, hl)
        end
      end
    end, 200)
  end,
})

-- Show diagnostic float automatically when cursor rests on an error
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = true, scope = "cursor" })
  end,
})

-- Auto-save when focus is lost or buffer is left
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    pattern = "*",
    command = "silent! wa",
})
