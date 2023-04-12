---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.spectre = {
  -- Always commit your files before you replace text. nvim-spectre does not support undo directly. 
  -- You need to use <Esc> not <C-c> to leave insert mode.
  n = {
    ["<leader>sw"] = {
      function ()
        require("spectre").open_visual({select_word=true})
      end,
      "search current word"
    },

    ["<leader>sp"] = {
      function ()
        require("spectre").open_file_search()
      end,
      "open search"
    }
  }
}

M.osc52 = {
  plugin = true,

  x = {
    ["<leader>by"] = {
        'require("osc52").copy_visual', "copy select section"
    }

  }
}

return M
