return {
    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                -- C/C++
                -- "clangd",
                "clang-format",
                "codelldb",

                -- Python
                "pyright",
                "mypy",
                "ruff",
                "black",
                "isort",
                "flake8",
                "pylint",

                -- SQL
                "sql-formatter",

                -- JS/TS, Web dev
                "nextls",
                "eslint-lsp",
                "js-debug-adapter",
                "prettierd",
                "typescript-language-server",
                "tailwindcss-language-server",
                "yaml-language-server",
                "yamlfix",
                "yamllint",
                "html-lsp",
                "css-lsp",
                "mdformat",

                -- Lua
                "lua-language-server",
                "stylua",

                -- Go
                "gopls",
                "goimports-reviser",
                "golines",
                "gofumpt",

                -- Shell
                "bash-language-server",
                "shellcheck",
                "shfmt",

                -- Docker
                "dockerfile-language-server",
                "docker-compose-language-service",

                -- Markdown
                "markdownlint",

                -- json:
                "json-lsp",
                "json-to-struct",
                "biome",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            mr.refresh(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local ok, p = pcall(mr.get_package, tool)
                    if ok and not p:is_installed() and not p:is_installing() then
                        p:install()
                    end
                end
            end)
        end,
    },
}
