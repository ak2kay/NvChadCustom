---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["ggg"] = { "gg", "go to first line", opts = { nowait = true } },

    ["Y"] = { "y$", "yank to the end of line" },

    -- center search
    ["n"] = { "nzzzv", "next search result" },
    ["N"] = { "Nzzzv", "previous search result" },

    -- pase last yanked, not deleted
    ["<leader>p"] = { '"0p', "paste last yanked text below" },
    ["<leader>P"] = { '"0P', "paste last yanked text above" },
  },
  v = {
    ["J"] = { ":m '>+1<CR>gv=gv", "move selected lines down" },
    ["K"] = { ":m '<-2<CR>gv=gv", "move selected lines up" },
    ["<"] = { "<gv", "shift selected lines left" },
    [">"] = { ">gv", "shift selected lines right" },
  },
}

M.ctrlsf = {
  plugin = true,

  n = {
    ["<leader>rw"] = { "<cmd> CtrlSF <CR>", "search current work under cursor" },
  },
}

M.osc52 = {
  plugin = true,

  x = {
    ["<leader>c"] = {
      function()
        require("osc52").copy_visual()
      end,
      "copy select section",
    },
  },
}

M.glance = {
  plugin = true,

  n = {
    ["ggd"] = { "<cmd>Glance definitions<cr>", "have a glance at definition" },
    ["ggr"] = { "<cmd>Glance references<cr>", "have a glance at references" },
    ["ggi"] = { "<cmd>Glance implementations<cr>", "have a glance at implementations" },
  },
}

M.gotopreview = {
  plugin = true,

  n = {
    ["gpd"] = {
      function()
        require("goto-preview").goto_preview_definition()
      end,
      "preview definition in float window",
    },
    ["gpi"] = {
      function()
        require("goto-preview").goto_preview_implementation()
      end,
      "preview implementation in float window",
    },
    ["gpr"] = {
      function()
        require("goto-preview").goto_preview_references()
      end,
      "preview references in float window",
    },
    ["gP"] = {
      function()
        require("goto-preview").close_all_win()
      end,
      "close all preview windows",
    },
  },
}

M.copilot = {
  plugin = true,

  i = {
    -- we use <c-y> to accept copilot suggestion
    -- and the reason we add `replace_keycodes = false` is that
    -- if we don't do this, random keycodes will be inserted, see [community discussion 29817](https://github.com/orgs/community/discussions/29817#discussioncomment-4217615) for details.
    ["<c-y>"] = {
      'copilot#Accept("<CR>")',
      "accept copilot suggestion",
      opts = { expr = true, silent = true, script = true, replace_keycodes = false },
    },
  },
}

M.harpoon = {
  plugin = true,

  n = {
    ["<c-p>"] = {
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      "toggle harpoon quick menu",
    },
    ["<c-b>"] = {
      function()
        require("harpoon.mark").add_file()
      end,
      "add current file to harpoon",
    },
  },
}

M.ufo = {
  plugin = true,

  n = {
    ["zR"] = {
      function()
        require("ufo").openAllFolds()
      end,
      "open all folds",
    },
    ["zM"] = {
      function()
        require("ufo").closeAllFolds()
      end,
      "close all folds",
    },
    ["zr"] = {
      function()
        require("ufo").openFoldsExceptKinds()
      end,
      "open more folds",
    },
    ["zm"] = {
      function()
        require("ufo").closeFoldsWith()
      end,
      "close more folds",
    },
    ["K"] = {
      function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
      "peek folds"
    },
  },
}

return M
