require("nvchad.autocmds")

-- Diagnostic display: no inline virtual_text, rounded float border
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.diagnostic.config({
      virtual_text = false,
      float = {
        border = "rounded",
        source = true,
      },
      signs = true,
      underline = true,
    })
  end,
  once = true,
})

-- Run formatter.nvim on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  command = "FormatWriteLock",
})

-- Diagnostic float on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = true, scope = "cursor" })
  end,
})

-- Auto-save on focus loss / buffer leave
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  pattern = "*",
  command = "silent! wa",
})
