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
  },
  indent = {
    enable = true,
  },
}

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
  extensions_list = { "themes", "terms", "fzf" },
}

M.indentblankline = {
  buftype_exclude = { "terminal", "nofile" },
  show_trailing_blankline_indent = true,
}

return M
