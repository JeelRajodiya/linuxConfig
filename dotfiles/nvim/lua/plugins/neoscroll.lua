return {
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      easing = "quadratic",
      duration_multiplier = 0.5,
      -- Only animate keyboard scrolling, not mouse
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
    },
  },
}
