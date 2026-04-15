-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local o = vim.opt

-- Enable true color support
o.termguicolors = true

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

o.encoding = "utf-8"
o.fileencoding = "utf-8"

-- disable word wrap:
o.wrap = false
o.sidescroll = 10
o.sidescrolloff = 10
o.scrolloff = 8
o.cursorline = true
o.cursorlineopt = "number"

o.number = true
o.relativenumber = true

-- shell and search settings
o.shell = "zsh"
o.ignorecase = true
o.smartcase = true
o.clipboard = "unnamedplus"
o.laststatus = 3

o.guicursor = "n-v-c:block-blinkwait700-blinkon400-blinkoff250,i:ver25-blinkwait700-blinkon400-blinkoff250,r:hor20-blinkwait700-blinkon400-blinkoff250"

-- Disable inline virtual text (applied via autocmd to override LazyVim defaults)
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
