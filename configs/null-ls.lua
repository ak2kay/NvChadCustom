local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- go
  b.formatting.gofumpt, -- Enforce a stricter format than gofmt, while being backwards compatible. That is, gofumpt is happy with a subset of the formats that gofmt is happy with.
  b.formatting.goimports, -- Updates your Go import lines, adding missing ones and removing unreferenced ones.

  -- json
  b.formatting.fixjson,

  -- yaml
  b.formatting.yamlfmt
}

null_ls.setup {
  debug = true,
  sources = sources,
}
