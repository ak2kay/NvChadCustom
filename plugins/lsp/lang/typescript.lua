return {
  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "pmizio/typescript-tools.nvim",
      init = function()
        require("custom.lazyvim.util").lsp.on_attach(function(client, buffer)
          if client.name == "tsserver" then
            vim.keymap.set("n", "<leader>co", "TSToolOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
            vim.keymap.set("n", "<leader>cR", "TSToolsRenameFile", { desc = "Rename File", buffer = buffer })
          end
        end)
      end,
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cR",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Remove Unused Imports",
            },
          },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
    },
  },
}
