return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "ray-x/cmp-treesitter",
    },
    opts = function(_, opts)
      local cmp = require "cmp"

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
      end

      local patched_opts = {
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

      opts = vim.tbl_deep_extend("force", opts, patched_opts)
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

  -- Fast and feature-rich surround actions. For text that includes
  -- surrounding characters like brackets or quotes, this allows you
  -- to select the text inside, change or modify the surrounding characters,
  -- and more.
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },

  -- comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
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

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },
  {
    -- "ThePrimeagen/git-worktree.nvim",
    "brandoncc/git-worktree.nvim", -- use forked version to fix telescope related error
    branch = "catch-and-handle-telescope-related-error",
    keys = { "<leader>ge", "<leader>gce" },
    config = function()
      local Worktree = require "git-worktree"

      Worktree.on_tree_change(function(op, metadata)
        if op == Worktree.Operations.Switch then
          print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
        end
      end)
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
  },
  -- DB
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
}
