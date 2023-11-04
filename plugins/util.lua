return {
  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = true,
  },
  -- yank through ssh
  {
    "ojroques/nvim-osc52",
    -- stylua: ignore
    keys = {
      { "<leader>c", function() require("osc52").copy_visual() end, desc = "copy select section", mode = "x" },
    },
  },
  { "LazyVim/LazyVim", module = "lazyvim" },
}
