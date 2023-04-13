local spec = {
  "ojroques/nvim-osc52",
  init = function()
    require("core.utils").load_mappings "osc52"
  end,
  event = "BufRead",
}

return spec
