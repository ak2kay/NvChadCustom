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

  -- lsp
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        "SmiteshP/nvim-navic",
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "SmiteshP/nvim-navbuddy",
    cmd = "Navbuddy",
    event = { "CmdlineEnter" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "SmiteshP/nvim-navic",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities

      require("typescript").setup {
        disable_commands = false,
        debug = false,
        go_to_source_definition = {
          fallback = true,
        },
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
      }
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = { "rust" },
    config = function()
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities

      local rt = require "rust-tools"

      rt.setup {
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufRead" },
    config = function()
      require "custom.configs.null-ls"
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
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
        ["bash"] = true,
      }
    end,
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings "dap"
    end,
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("custom.configs.dap").setup()
    end,
  },
  {
    "leoluz/nvim-dap-go",
    init = function()
      require("core.utils").load_mappings "dapgo"
    end,
    ft = { "go" },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = true,
  },
  {
    "mfussenegger/nvim-dap-python",
    init = function()
      require("core.utils").load_mappings "dappy"
    end,
    ft = { "python" },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("dap-python").setup("python", {})
    end,
  },

  -- override plugin configs
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = overrides.indentblankline,
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

  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
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

  -- tmux related
  {
    "tpope/vim-obsession",
    event = {
      "BufEnter",
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    init = function()
      require("core.utils").load_mappings "navigation"
    end,
    event = { "BufEnter" },
    config = function()
      local nvim_tmux_nav = require "nvim-tmux-navigation"

      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }
    end,
  },

  {
    "folke/noice.nvim",
    event = { "BufEnter" },
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = false,
          },
          signature = {
            enabled = false,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- Search && replace tool in global scope
  {
    "dyng/ctrlsf.vim",
    init = function()
      require("core.utils").load_mappings "ctrlsf"
    end,
    cmd = { "CtrlSF" },
    keys = { [[<leader>rw]] },
    config = function()
      vim.g["ctrlsf_auto_focus"] = { at = "start" }
      vim.g["ctrlsf_position"] = "right"
    end,
  },

  -- yank through ssh
  {
    "ojroques/nvim-osc52",
    init = function()
      require("core.utils").load_mappings "osc52"
    end,
    event = "BufRead",
  },

  -- generate shareable file link of git repo
  {
    "ruifm/gitlinker.nvim",
    keys = { [[<leader>gy]] }, -- this is the built-in keymap
    dependencies = { "ojroques/vim-oscyank", "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup {
        opts = {
          action_callback = function(url)
            -- yank to unnamed register
            vim.api.nvim_command("let @\" = '" .. url .. "'")
            -- copy to the system clipboard using OSC52
            --[[ vim.fn.OSCYankString(url) ]]
            require("osc52").copy(url)
          end,
        },
        callbacks = {
          ["git-pd.megvii-inc.com"] = require("gitlinker.hosts").get_gitlab_type_url,
        },
      }
    end,
  },

  -- lsp preview
  {
    "rmagatti/goto-preview",
    init = function()
      require("core.utils").load_mappings "gotopreview"
    end,
    event = "BufRead",
    config = true,
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },

  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },

  -- lsp glance
  { import = "custom.configs.glance" },

  -- folds
  { import = "custom.configs.ufo" },
}

return plugins
