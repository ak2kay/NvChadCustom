local null_ls = require "null-ls"
local b = null_ls.builtins

local with_diagnostics_code = function(builtin)
  return builtin.with {
    diagnostics_format = "[#{c}] #{m} (#{s})",
  }
end

local on_attach = function()
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.c", "*.h", "*.lua", "*.go", "*.js", "*.ts", "*.tsx", "*.json", "*.yaml", "*.yml", "*.sh" },
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

null_ls.setup {
  sources = {
    b.formatting.stylua,
    b.formatting.black.with { extra_args = { "--fast" } },
    b.formatting.clang_format, -- it also formats proto
    b.formatting.deno_fmt.with {
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
  },
  on_attach = on_attach,
}
