-- Glob patterns to always exclude from search (large/generated dirs)
local exclude_globs = {
  "!.git/",
  "!**/.DS_Store",
  "!**/node_modules/",
  "!**/target/",       -- Rust/Maven
  "!**/.next/",        -- Next.js
  "!**/dist/",
  "!**/build/",
  "!**/__pycache__/",
  "!**/.venv/",
  "!**/vendor/",       -- Go/PHP
  "!**/.gradle/",
  "!**/Pods/",         -- iOS
}

-- Build rg glob args: { "--glob=!.git/", "--glob=!node_modules/", ... }
local function glob_args()
  local args = {}
  for _, pat in ipairs(exclude_globs) do
    table.insert(args, "--glob=" .. pat)
  end
  return args
end

-- Base rg arguments for live grep
local function vimgrep_args()
  local args = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "--hidden",
    "--no-ignore",
    "--max-filesize=1M",
  }
  for _, g in ipairs(glob_args()) do
    table.insert(args, g)
  end
  return args
end

-- Build find_files command
local function find_cmd()
  local args = { "rg", "--files", "--hidden", "--no-ignore", "--max-filesize=1M" }
  for _, g in ipairs(glob_args()) do
    table.insert(args, g)
  end
  return args
end

return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        vimgrep_arguments = vimgrep_args(),
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = find_cmd(),
        },
      },
    },
  },
}
