local M = {
  "ruifm/gitlinker.nvim",
  keys = { [[<leader>gy]] }, -- this is the built-in keymap
  dependencies = { "ojroques/vim-oscyank", "nvim-lua/plenary.nvim" },
}

function M.config()
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
end

return M
