require("nvchad.mappings")

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Escape in insert mode
map("i", "kj", "<Esc>", { noremap = false })

-- Delete whole word with Ctrl+Backspace in insert mode
map("i", "<C-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete word backward" })
map("i", "<C-H>", "<C-w>", { noremap = true, silent = true, desc = "Delete word backward (alternative)" })
map("i", "<M-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete word backward (Alt+Backspace)" })

-- editing
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Ctrl+C: Copy all to system clipboard, keep cursor position
map("n", "<C-c>", 'mzggVG"+y`z', opts)

-- Mouse settings
vim.opt.mouse = "a"
vim.keymap.set("n", "<LeftDrag>", "<Nop>", { silent = true })
map("n", "<S-ScrollWheelUp>", "10zh", { noremap = true, silent = true })
map("n", "<S-ScrollWheelDown>", "10zl", { noremap = true, silent = true })

-- harpoon
map("n", "<leader>ah", "<cmd>lua require('harpoon.mark').add_file()<CR>", { desc = "Add mark" })
map("n", "<leader>lh", "<cmd>Telescope harpoon marks<CR>", { desc = "Toggle mark telescope" })
map("n", "<leader>fm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { desc = "Toggle mark menu" })

-- Move lines
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move line down" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move line up" })

-- tabs
map("n", "<M-]>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<M-[>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Change without yanking
map("n", "c", '"_c', opts)
map("n", "C", '"_C', opts)
map("v", "c", '"_c', opts)

-- indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Go tags
map("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
map("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })

-- Home/End
map("n", "<Home>", "0", opts)
map("n", "<End>", "$", opts)
map("i", "<Home>", "<C-o>0", opts)
map("i", "<End>", "<C-o>$", opts)
map("c", "<Home>", "<C-b>", opts)
map("c", "<End>", "<C-e>", opts)

-- Terminal <Find>/<Select> compatibility
map("i", "<Find>", "<C-o>0", opts)
map("i", "<Select>", "<C-o>$", opts)
map("n", "<Find>", "0", opts)
map("n", "<Select>", "$", opts)
map("c", "<Find>", "<C-b>", opts)
map("c", "<Select>", "<C-e>", opts)

-- Focused diagnostic float
vim.keymap.set("n", "<leader>ce", function()
  vim.diagnostic.open_float(nil, { focusable = true, scope = "line" })
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { desc = "Focus diagnostic float (copyable)" })

-- VSCode-style find and replace
map("n", "<C-h>", ":%s//g<Left><Left>", { noremap = true, desc = "Find and replace" })
