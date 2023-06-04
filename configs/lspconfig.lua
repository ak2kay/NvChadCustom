local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local navic = require "nvim-navic"
local navbuddy = require "nvim-navbuddy"
local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
    navbuddy.attach(client, bufnr)
  end
end

local lspconfig = require "lspconfig"

local servers = { "gopls", "pyright" }

local server_opts = {
  gopls = {
    settings = {
      gopls = {
        analyses = {
          nilness = true,
          shadow = true,
          unusedparams = true,
          unusedvariable = true,
          unusedwrite = true,
        },
        staticcheck = true,
      },
    },
  },
}

local default_opts = {
  on_attach = custom_on_attach,
  capabilities = capabilities,
}

local function merge_opts(server_name)
  local custom_opts = {}
  if server_opts[server_name] ~= nil then
    custom_opts = server_opts[server_name]
  end
  return vim.tbl_deep_extend("force", default_opts, custom_opts)
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup(merge_opts(lsp))
end
