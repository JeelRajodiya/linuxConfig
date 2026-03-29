return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff (split)" },
      { "<leader>gf", "<cmd>Git log --oneline %<cr>", desc = "File history" },
      { "<leader>gh", "<cmd>Git log --oneline<cr>", desc = "Branch history" },
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
    },
  },
}
