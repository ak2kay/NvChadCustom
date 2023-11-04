return {
  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      buftype_exclude = { "terminal", "nofile", "help", "dashboard", "alpha", "Trouble", "lazy", "mason" },
      show_trailing_blankline_indent = true,
    },
  },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",
                                                                                                                                    desc =
        "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end,                                   desc =
      "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end,                                desc =
      "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc =
      "Dismiss All" },
      { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,
                                                                                                                                    expr = true,
                                                                                                                                                              desc =
        "Scroll forward",                                                                                                                                                             mode = {
        "i", "n", "s" } },
      { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,
                                                                                                                                    expr = true,
                                                                                                                                                              desc =
        "Scroll backward",                                                                                                                                                            mode = {
        "i", "n", "s" } },
    },
  },
  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.93,
        width = 150,
        height = 1,
      },
      plugins = {
        options = {
          showcmd = true, -- disables the command in the last line of the screen
        },
        twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = true }, -- disables git signs
      },
    },
  },
}
