local setup = function(_, opts)
  local on_attach = require("plugins.configs.lspconfig").on_attach
  local capabilities = require("plugins.configs.lspconfig").capabilities

  local lspconfig = require "lspconfig"
  local navic = require "nvim-navic"

  -- List of servers to install
  local servers = { "html", "cssls", "tsserver", "clangd", "gopls" }

  require("mason").setup(opts)

  require("mason-lspconfig").setup {
    ensure_installed = servers,
  }

  -- This will setup lsp for servers you listed above
  -- And servers you install through mason UI
  -- So defining servers in the list above is optional
  require("mason-lspconfig").setup_handlers {
    -- Default setup for all servers, unless a custom one is defined below
    function(server_name)
      lspconfig[server_name].setup {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
          end
        end,
        capabilities = capabilities,
      }
    end,
    -- custom setup for a server goes after the function above
    -- Example, override rust_analyzer
    -- ["rust_analyzer"] = function ()
    --   require("rust-tools").setup {}
    -- end,
    -- Another example with clangd
    -- Users usually run into different offset_encodings issue,
    -- so this is how to bypass it (kindof)
    ["clangd"] = function()
      lspconfig.clangd.setup {
        cmd = {
          "clangd",
          "--offset-encoding=utf-16", -- To match null-ls
          --  With this, you can configure server with
          --    - .clangd files
          --    - global clangd/config.yaml files
          --  Read https://clangd.llvm.org/config for more information
          "--enable-config",
        },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
      }
    end,

    -- Example: disable auto configuring an LSP
    -- Here, we disable lua_ls so we can use NvChad's default config
    ["lua_ls"] = function() end,

    ["yamlls"] = function()
      lspconfig.yamlls.setup {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      }
    end,
  }

  require("null-ls").setup {}
  require("mason-null-ls").setup {
    ensure_installed = {
      "stylua",
      "clang_format",
      "gofumpt",
      "goimports",
      "fixjson",
      "yamlfmt",
      "deno_fmt", -- choosed deno for ts/js files cuz it's very fast
      "prettier",
    },
    automatic_setup = true,
    handlers = {
      prettier = function()
        local null_ls = require "null-ls"
        null_ls.register(null_ls.builtins.formatting.prettier.with { filetypes = { "html", "markdown", "css" } })
      end,
    },
  }
end

---@type NvPluginSpec
local spec = {
  "neovim/nvim-lspconfig",
  -- BufRead is to make sure if you do nvim some_file then this is still going to be loaded
  event = { "VeryLazy", "BufRead", "BufNewFile" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      config = function(plugin, opts)
        setup(plugin, opts)
      end,
    },
    "williamboman/mason-lspconfig",
    "jose-elias-alvarez/null-ls.nvim",
    "jay-babu/mason-null-ls.nvim",
    {
      "SmiteshP/nvim-navbuddy",
      cmd = "Navbuddy",
      event = { "CmdlineEnter" },
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
    },
    {
      "j-hui/fidget.nvim",
      event = "BufReadPre",
      config = function()
        require("fidget").setup {}
      end,
    },
    {
      "SmiteshP/nvim-navic",
      event = { "BufReadPre", "BufNewFile" },
    },
  },
}

return spec
