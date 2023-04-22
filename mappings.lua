---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["ggg"] = { "gg", "go to first line", opts = { nowait = true } },
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

return M
