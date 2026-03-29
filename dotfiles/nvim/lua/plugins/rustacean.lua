return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    init = function()
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
      vim.g.rustaceanvim = {
        dap = {
          adapter = {
            type = "server",
            port = "${port}",
            host = "127.0.0.1",
            executable = {
              command = mason_path .. "adapter/codelldb",
              args = { "--liblldb", mason_path .. "lldb/lib/liblldb.dylib", "--port", "${port}" },
            },
          },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    config = function() end,
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
}
