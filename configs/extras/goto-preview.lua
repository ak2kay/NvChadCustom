local spec = {
  "rmagatti/goto-preview",
  init = function()
    require("core.utils").load_mappings "gotopreview"
  end,
  event = "BufRead",
  config = true,
}

return spec
