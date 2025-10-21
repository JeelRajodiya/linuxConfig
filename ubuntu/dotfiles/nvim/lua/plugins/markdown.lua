return {
  -- Render markdown in Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      -- Render automatically when opening markdown files
      enabled = true,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>mr",
        "<cmd>RenderMarkdown toggle<cr>",
        desc = "Toggle Markdown Render",
      },
    },
  },
  -- Auto-formatting for markdown
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    config = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_set_mappings = 1
      vim.g.bullets_mapping_leader = ""
      vim.g.bullets_delete_last_bullet_if_empty = 1
    end,
  },
  -- Table mode for markdown
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
    init = function()
      vim.g.table_mode_map_prefix = "<leader>t"
    end,
  },
}
