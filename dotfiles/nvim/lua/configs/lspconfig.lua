require("nvchad.configs.lspconfig").defaults()

-- Enabled language servers. Install via :MasonInstallAll or :Mason.
-- rust_analyzer is intentionally omitted: rustaceanvim manages it.
local servers = {
  "lua_ls",
  "gopls",
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "bashls",
  "pyright",
}

vim.lsp.enable(servers)
