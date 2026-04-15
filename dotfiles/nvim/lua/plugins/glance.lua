return {
  {
    "DNLHC/glance.nvim",
    event = "LspAttach",
    keys = {
      { "gD", "<cmd>Glance definitions<cr>", desc = "Glance: peek definition" },
      { "gR", "<cmd>Glance references<cr>", desc = "Glance: peek references" },
      { "gY", "<cmd>Glance type_definitions<cr>", desc = "Glance: peek type definition" },
      { "gM", "<cmd>Glance implementations<cr>", desc = "Glance: peek implementations" },
    },
    opts = {
      border = { enable = true },
      theme = { enable = true, mode = "auto" },
      detach = function(winid)
        return vim.api.nvim_win_get_width(winid) < 100
      end,
    },
  },
}
