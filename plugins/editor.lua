local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = true,
      },

      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
      view = {
        relativenumber = true,
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
      },
    },
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
  {
    "nvim-telescope/telescope.nvim",
    version = false, -- telescope did only one release, so use HEAD for now
    -- disable all default telescope mappings
    init = function() end,
    -- stylua: ignore
    keys = {
      { "<leader>ff", "<cmd> Telescope find_files <CR>",                                        desc = "Find files" },
      { "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", desc = "Find all" },
      { "<leader>/",  "<cmd> Telescope live_grep <CR>",                                         desc = "Live grep" },
      { "<leader>fb", "<cmd> Telescope buffers <CR>",                                           desc = "Find buffers" },
      { "<leader>fh", "<cmd> Telescope help_tags <CR>",                                         desc = "Help page" },
      { "<leader>fo", "<cmd> Telescope oldfiles <CR>",                                          desc = "Find oldfiles" },
      {
        "<leader>fz",
        "<cmd> Telescope current_buffer_fuzzy_find <CR>",
        desc =
        "Find in current buffer"
      },
      -- git
      { "<leader>cm", "<cmd> Telescope git_commits <CR>", desc = "Git commits" },
      { "<leader>gt", "<cmd> Telescope git_status <CR>",  desc = "Git status" },
      -- pick a hidden term
      { "<leader>pt", "<cmd> Telescope terms <CR>",       desc = "Pick hidden term" },
      -- theme switcher
      { "<leader>th", "<cmd> Telescope themes <CR>",      desc = "Nvchad themes" },
      {
        "<leader>ma",
        "<cmd> Telescope marks <CR>",
        desc =
        "telescope bookmarks"
      },
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
      {
        "<leader>gB",
        function() require("telescope.builtin").git_branches {} end,
        desc =
        "find branches"
      },
      {
        "<leader>ge",
        function() require("telescope").extensions.git_worktree.git_worktrees() end,
        desc =
        "switch git worktree"
      },
      {
        "<leader>gce",
        function() require("telescope").extensions.git_worktree.create_git_worktree() end,
        desc =
        "create git worktree"
      },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { ".git", "node_modules" },
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        generic_sorter = require("telescope.sorters").get_generic_fzy_sorter,
        preview = {
          filesize_hook = function(filepath, bufnr, opts)
            local max_bytes = 10000
            local cmd = { "head", "-c", max_bytes, filepath }
            require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
          end,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },
      extensions_list = { "themes", "terms", "fzf", "git_worktree" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufNewFile", "BufReadPre" },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    -- stylua: ignore
    keys = {
      {
        "<C-h>",
        function() require("nvim-tmux-navigation").NvimTmuxNavigateLeft() end,
        desc = "navigate left",
        mode = {
          "i", "n" }
      },
      {
        "<C-j>",
        function() require("nvim-tmux-navigation").NvimTmuxNavigateDown() end,
        desc = "navigate down",
        mode = {
          "i", "n" }
      },
      {
        "<C-k>",
        function() require("nvim-tmux-navigation").NvimTmuxNavigateUp() end,
        desc = "navigate up",
        mode = {
          "i", "n" }
      },
      {
        "<C-l>",
        function() require("nvim-tmux-navigation").NvimTmuxNavigateRight() end,
        desc = "navigate right",
        mode = {
          "i", "n" }
      },
      {
        "<C-\\>",
        function() require("nvim-tmux-navigation").NvimTmuxNavigateLastActive() end,
        desc =
        "navigate last active",
        mode = {
          "i", "n" }
      },
      {
        "<C-Space>",
        function() require("nvim-tmux-navigation").NvimTmuxNavigateNext() end,
        desc = "navigate next",
        mode = {
          "i", "n" }
      },
    },
    config = function()
      local nvim_tmux_nav = require "nvim-tmux-navigation"

      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }
    end,
  },
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
      { "<c-b>", function() require("harpoon.mark").add_file() end,        desc = "add current file to harpoon" },
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

  { "ellisonleao/glow.nvim", config = true, cmd = { "Glow", "GlowInstall" } },

  -- markdown format
  { "hotoo/pangu.vim", ft = { "markdown" } },

  -- folds
  {
    "kevinhwang91/nvim-ufo",
    -- stylua: ignore
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,         desc = "open all folds", },
      { "zM", function() require("ufo").closeAllFolds() end,        desc = "close all folds", },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "open more folds", },
      { "zm", function() require("ufo").closeFoldsWith() end,       desc = "close more folds", },
      {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "peek folds",
      },
    },
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          }
        end,
      },
    },
    opts = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      return {
        fold_virt_text_handler = handler,
        close_fold_kinds = { "imports", "comment" },
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      }
    end,
    config = function(_, opts)
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

      -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
      -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
      require("ufo").setup(opts)
    end,
  },
}
