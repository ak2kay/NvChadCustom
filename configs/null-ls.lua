local null_ls = require "null-ls"
local b = null_ls.builtins
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local with_diagnostics_code = function(builtin)
  return builtin.with {
    diagnostics_format = "[#{c}] #{m} (#{s})",
  }
end

local on_attach = function(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds {
      group = augroup,
      buffer = bufnr,
    }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { bufnr = bufnr }
      end,
    })
  end
end

null_ls.setup {
  sources = {
    b.formatting.stylua,
    b.formatting.black.with { extra_args = { "--fast" } },
    b.formatting.clang_format, -- it also formats proto
    b.formatting.prettierd.with {
      filetypes = { "javascript", "javascriptreact", "jsonc", "markdown", "typescript", "typescriptreact" },
    },
    b.formatting.gofumpt,
    b.formatting.goimports,
    b.formatting.jq,
    b.formatting.shfmt,
    b.formatting.terraform_fmt,
    b.formatting.yamlfmt,

    with_diagnostics_code(b.diagnostics.eslint_d),
    with_diagnostics_code(b.diagnostics.buf),
    with_diagnostics_code(b.diagnostics.golangci_lint),
    with_diagnostics_code(b.diagnostics.shellcheck),
    with_diagnostics_code(b.diagnostics.zsh),
    with_diagnostics_code(b.diagnostics.mypy),
    with_diagnostics_code(b.diagnostics.ruff),
  },
  on_attach = on_attach,
}
