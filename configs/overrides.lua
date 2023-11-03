local M = {}

M.mason = {
  ensure_installed = {
    -- dap
    "codelldb",
  },
}

M.treesitter = {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "regex",
    "tsx",
    "typescript",
    "vim",
    "sql",
  },
  indent = {
    enable = true,
  },
}

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

-- git support in nvimtree
M.nvimtree = {
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
}

-- telescope
M.telescope = {
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
}

M.indentblankline = {
  buftype_exclude = { "terminal", "nofile" },
  show_trailing_blankline_indent = true,
}

return M
