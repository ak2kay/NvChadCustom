---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
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
    ["<leader>by"] = {
      'require("osc52").copy_visual',
      "copy select section",
    },
  },
}

return M
