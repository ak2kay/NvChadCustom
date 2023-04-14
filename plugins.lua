local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        -- copilot cmp source
        "zbirenbaum/copilot-cmp",
        dependencies = {
          {
            -- fully featured & enhanced replacement for copilot.vim
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            opts = {
              suggestion = { enabled = false },
              panel = { enabled = false },
            },
          },
        },
        config = true,
      },
    },

    opts = function()
      local utils = require "custom.utils"
      local base_options = require "plugins.configs.cmp"
      local cmp = require "cmp"

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
      end

      local opts = {
        mapping = {
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          },

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            elseif require("luasnip").expand_or_jumpable() then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        },
        sources = utils.merge_table_simple({
          { name = "copilot", group_index = 2 },
        }, base_options.sources),
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }

      opts = vim.tbl_deep_extend("force", base_options, opts)
      return opts
    end,
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- Use a extras plugin
  { import = "custom.configs.extras.lsp-extras" },

  -- Search && replace tool in global scope
  { import = "custom.configs.extras.ctrlsf" },

  -- yank through ssh
  { import = "custom.configs.extras.osc52" },

  -- generate shareable file link of git repo
  { import = "custom.configs.extras.gitlinker" },

  -- lsp glance
  { import = "custom.configs.extras.glance" },

  -- lsp preview
  { import = "custom.configs.extras.goto-preview" },

  -- vim-fugitive
  { import = "custom.configs.extras.fugitive" },
}

return plugins
