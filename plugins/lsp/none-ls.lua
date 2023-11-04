local Util = require "custom.lazyvim.util"

return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    init = function()
      Util.on_very_lazy(function()
        -- register the formatter with LazyVim
        require("custom.lazyvim.util").format.register {
          name = "none-ls.nvim",
          priority = 200, -- set higher than conform, the builtin formatter
          primary = true,
          format = function(buf)
            return Util.lsp.format {
              bufnr = buf,
              filter = function(client)
                return client.name == "null-ls"
              end,
            }
          end,
          sources = function(buf)
            local ret = require("null-ls.sources").get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING") or {}
            return vim.tbl_map(function(source)
              return source.name
            end, ret)
          end,
        }
      end)
    end,
    opts = function(_, opts)
      local nls = require "null-ls"
      local b = nls.builtins
      local with_diagnostics_code = function(builtin)
        return builtin.with {
          diagnostics_format = "[#{c}] #{m} (#{s})",
        }
      end

      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, {
        b.formatting.stylua,
        b.formatting.black.with { extra_args = { "--fast" } },
        b.formatting.clang_format, -- it also formats proto
        b.formatting.prettierd.with {
          filetypes = { "javascript", "javascriptreact", "markdown", "typescript", "typescriptreact" },
        },
        b.formatting.gofumpt,
        b.formatting.goimports,
        b.formatting.shfmt,
        b.formatting.terraform_fmt,
        b.formatting.yamlfmt,
        b.formatting.fixjson,

        with_diagnostics_code(b.diagnostics.eslint_d),
        with_diagnostics_code(b.diagnostics.golangci_lint),
        with_diagnostics_code(b.diagnostics.shellcheck),
        with_diagnostics_code(b.diagnostics.zsh),
      })
    end,
  },
}
