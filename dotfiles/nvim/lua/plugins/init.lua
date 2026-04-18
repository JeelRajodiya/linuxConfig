return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig")
    end,
  },

  -- nvim-ts-autotag hooks into NvChad's bundled treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "bash",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "go",
        "gomod",
        "gowork",
        "rust",
        "toml",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
      },
    },
  },

  -- LuaSnip: load user VSCode-format snippets from lua/snippets/
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
      })
    end,
  },
}
