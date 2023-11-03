local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "ray-x/cmp-treesitter",
    },
    opts = function()
      local base_options = require "plugins.configs.cmp"
      local cmp = require "cmp"

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
      end

      local opts = {
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
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
        sources = {
          -- { name = "copilot", group_index = 2 },
          { name = "buffer", max_item_count = 4, priority = 3 },
          { name = "treesitter", max_item_count = 4, priority = 1 },
          { name = "nvim_lsp", max_item_count = 6, group_index = 2, priority = 2 },
          { name = "nvim_lua", max_item_count = 4, priority = 2 },
          { name = "luasnip", max_item_count = 2, priority = 5 },
          { name = "path", max_item_count = 2, priority = 4 },
        },
        enabled = function()
          local buftype = vim.api.nvim_buf_get_option(0, "buftype")
          if buftype == "prompt" or buftype == "nofile" then
            return false
          end
          return true
        end,
      }

      opts = vim.tbl_deep_extend("force", base_options, opts)
      return opts
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)

      local autocomplete_group = vim.api.nvim_create_augroup("vimrc_autocompletion", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          cmp.setup.buffer {
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            },
          }
        end,
        group = autocomplete_group,
      })
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
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "SmiteshP/nvim-navic",
    ft = { "go", "rust", "python", "lua", "javascript", "typescript", "typescriptreact", "javascriptreact" },
  },
  {
    "j-hui/fidget.nvim",
    enabled = false,
    tag = "legacy",
    event = "LspAttach",
    config = true,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    config = function()
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities

      local tt = require "typescript-tools"

      tt.setup {
        on_attach = on_attach,
        capabilities = capabilities,
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
    cmd = { "Copilot" },
    -- stylua: ignore
    keys = {
      { "<c-y>", 'copilot#Accept("<CR>")', desc = "accept copilot suggestion", expr = true, silent = true, script = true, replace_keycodes = false, mode = "i" },
    },
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
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    -- stylua: ignore
    keys = {
      { "<leader>dd", function() require("dap").continue() end, desc = "start debugging" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "toggle breakpoint" },
      { "<leader>dso", function() require("dap").step_over() end, desc = "step over" },
      { "<leader>dsi", function() require("dap").step_into() end, desc = "step into" },
    },
    config = function()
      require("custom.configs.dap").setup()
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = { "go" },
    -- stylua: ignore
    keys = {
      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "debug current test of golang" },
      { "<leader>dglt", function() require("dap-go").debug_last_test() end, desc = "debug last test debuged of golang" },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = true,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    -- stylua: ignore
    keys = {
      { "<leader>dpt", function() require("dap-python").test_method() end, desc = "debug current test of python" },
    },
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
    version = false, -- telescope did only one release, so use HEAD for now
    -- disable all default telescope mappings
    init = function() end,
    -- stylua: ignore
    keys = {
      { "<leader>ff", "<cmd> Telescope find_files <CR>", desc = "Find files" },
      { "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", desc = "Find all" },
      { "<leader>/", "<cmd> Telescope live_grep <CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd> Telescope buffers <CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd> Telescope help_tags <CR>", desc = "Help page" },
      { "<leader>fo", "<cmd> Telescope oldfiles <CR>", desc = "Find oldfiles" },
      { "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", desc = "Find in current buffer" },
      -- git
      { "<leader>cm", "<cmd> Telescope git_commits <CR>", desc = "Git commits" },
      { "<leader>gt", "<cmd> Telescope git_status <CR>", desc = "Git status" },
      -- pick a hidden term
      { "<leader>pt", "<cmd> Telescope terms <CR>", desc = "Pick hidden term" },
      -- theme switcher
      { "<leader>th", "<cmd> Telescope themes <CR>", desc = "Nvchad themes" },
      { "<leader>ma", "<cmd> Telescope marks <CR>", desc = "telescope bookmarks" },
      {
        "<leader>fa",
        function()
          require("telescope.builtin").find_files {
            previewer = false,
            follow = false,
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true,
          }
        end,
        desc = "find all",
      },
      { "<leader>gB", function() require("telescope.builtin").git_branches {} end, desc = "find branches" },
      { "<leader>ge", function() require("telescope").extensions.git_worktree.git_worktrees() end, desc = "switch git worktree" },
      { "<leader>gce", function() require("telescope").extensions.git_worktree.create_git_worktree() end, desc = "create git worktree" },
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
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    },
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
    dependencies = "nvim-lua/plenary.nvim",
    -- stylua: ignore
    keys = {
      { "<c-p>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "toggle harpoon quick menu" },
      { "<c-b>", function() require("harpoon.mark").add_file() end, desc = "add current file to harpoon" },
    },
    config = function()
      require("harpoon").setup {
        menu = {
          width = math.floor(vim.api.nvim_win_get_width(0) / 2),
        },
        global_settings = {
          mark_branch = true,
        },
      }
    end,
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
    -- stylua: ignore
    keys = {
      { "<C-h>", function() require("nvim-tmux-navigation").NvimTmuxNavigateLeft() end, desc = "navigate left", mode = { "i", "n" } },
      { "<C-j>", function() require("nvim-tmux-navigation").NvimTmuxNavigateDown() end, desc = "navigate down", mode = { "i", "n" } },
      { "<C-k>", function() require("nvim-tmux-navigation").NvimTmuxNavigateUp() end, desc = "navigate up", mode = { "i", "n" } },
      { "<C-l>", function() require("nvim-tmux-navigation").NvimTmuxNavigateRight() end, desc = "navigate right", mode = { "i", "n" } },
      { "<C-\\>", function() require("nvim-tmux-navigation").NvimTmuxNavigateLastActive() end, desc = "navigate last active", mode = { "i", "n" } },
      { "<C-Space>", function() require("nvim-tmux-navigation").NvimTmuxNavigateNext() end, desc = "navigate next", mode = { "i", "n" } },
    },
    config = function()
      local nvim_tmux_nav = require "nvim-tmux-navigation"

      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }
    end,
  },

  -- Search && replace tool in global scope
  {
    "dyng/ctrlsf.vim",
    cmd = { "CtrlSF" },
    keys = {
      { "<leader>ws", ":CtrlSF <C-R><C-W><CR>", desc = "search current work under cursor" },
    },
    config = function()
      vim.g["ctrlsf_auto_focus"] = { at = "start" }
      vim.g["ctrlsf_position"] = "right"
    end,
  },

  -- yank through ssh
  {
    "ojroques/nvim-osc52",
    -- stylua: ignore
    keys = {
      { "<leader>c", function() require("osc52").copy_visual() end, desc = "copy select section", mode = "x" },
    },
  },

  -- generate shareable file link of git repo
  {
    "ruifm/gitlinker.nvim",
    keys = { { "<leader>gy", desc = "copy remote git link of current line or select" } }, -- this is the built-in keymap
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
    -- stylua: ignore
    keys = {
      { "gpd", function() require("goto-preview").goto_preview_definition() end, desc = "preview definition in float window" },
      { "gpi", function() require("goto-preview").goto_preview_implementation() end, desc = "preview implementation in float window" },
      { "gpr", function() require("goto-preview").goto_preview_references() end, desc = "preview references in float window" },
      { "gP", function() require("goto-preview").close_all_win() end, desc = "close all preview windows" },
    },
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

  {
    -- "ThePrimeagen/git-worktree.nvim",
    "brandoncc/git-worktree.nvim", -- use forked version to fix telescope related error
    branch = "catch-and-handle-telescope-related-error",
    keys = { "<leader>ge", "<leader>gce" },
    config = function()
      local Worktree = require "git-worktree"

      -- op = Operations.Switch, Operations.Create, Operations.Delete
      -- metadata = table of useful values (structure dependent on op)
      --      Switch
      --          path = path you switched to
      --          prev_path = previous worktree path
      --      Create
      --          path = path where worktree created
      --          branch = branch name
      --          upstream = upstream remote name
      --      Delete
      --          path = path where worktree deleted

      Worktree.on_tree_change(function(op, metadata)
        if op == Worktree.Operations.Switch then
          print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
        end
      end)
    end,
  },

  {
    "sebdah/vim-delve",
    ft = { "go" },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        commands = {
          all = {
            view = "split",
            opts = { enter = true, format = "details" },
            filter = {},
          },
        },
      }
    end,
  },
  {
    "dgagn/diagflow.nvim",
    event = "LspAttach",
    opts = {
      scope = "line",
      toggle_event = { "InsertEnter" },
    },
  },
}

return plugins
