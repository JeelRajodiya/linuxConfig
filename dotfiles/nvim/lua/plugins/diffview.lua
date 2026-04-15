return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>tab DiffviewOpen<cr>", desc = "Diffview: open diff" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: branch history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_horizontal" },
      },
    },
  },
}
