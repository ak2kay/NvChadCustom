local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "hrsh7th/nvim-cmp",
    opts = function()
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
      }

      opts = vim.tbl_deep_extend("force", base_options, opts)
      return opts
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup { _diagnostic_signs = true }
    end,
  },

  {
    "github/copilot.vim",
    event = { "BufRead", "BufNewFile" },
    init = function()
      require("core.utils").load_mappings "copilot"
    end,
    cmd = { "Copilot" },
    config = function()
      local g = vim.g

      g["copilot_no_tab_map"] = true
      g["copilot_assume_mapped"] = true
      g.copilot_filetypes = {
        ["*"] = false,
        ["javascript"] = true,
        ["typescript"] = true,
        ["lua"] = true,
        ["rust"] = true,
        ["c"] = true,
        ["c++"] = true,
        ["go"] = true,
        ["python"] = true,
      }
    end,
  },

  -- override plugin configs
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = overrides.telescope,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "ggandor/lightspeed.nvim",
    event = { "BufRead" },
  },

  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
  },

  -- better marks
  {
    "chentoast/marks.nvim",
    event = { "BufRead", "BufNewFile" },
    config = true,
  },

  -- better marks per project
  {
    "ThePrimeagen/harpoon",
    init = function()
      require("core.utils").load_mappings "harpoon"
    end,
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufRead", "BufNewFile" },
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- markdown preview
  { "ellisonleao/glow.nvim", config = true, cmd = { "Glow", "GlowInstall" } },

  -- markdown format
  { "hotoo/pangu.vim", ft = { "markdown" } },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require "custom.configs.zenmode"
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    dependencies = "nvim-lua/plenary.nvim",
  },

  {
    "tpope/vim-obsession",
    event = {
      "BufEnter",
    },
  },

  -- lsp-extra config
  { import = "custom.configs.lspconfig" },

  -- Search && replace tool in global scope
  { import = "custom.configs.ctrlsf" },

  -- yank through ssh
  { import = "custom.configs.osc52" },

  -- generate shareable file link of git repo
  { import = "custom.configs.gitlinker" },

  -- lsp glance
  { import = "custom.configs.glance" },

  -- lsp preview
  { import = "custom.configs.goto-preview" },

  -- vim-fugitive
  { import = "custom.configs.fugitive" },

  -- folds
  { import = "custom.configs.ufo" },
}

return plugins
