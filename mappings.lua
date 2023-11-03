---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<leader>fa"] = "",

    -- disable default keys. we will use those keys for nvim-tmux-navigation
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
  },

  i = {
    -- disable default keys. we will use those keys for nvim-tmux-navigation
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
  },
}

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

return M
