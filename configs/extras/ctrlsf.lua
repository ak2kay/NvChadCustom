local spec = {
  "dyng/ctrlsf.vim",
  init = function()
    require("core.utils").load_mappings "ctrlsf"
  end,
  cmd = { "CtrlSF" },
  keys = { [[<leader>rw]] },
  config = function()
    vim.g["ctrlsf_auto_focus"] = { at = "start" }
    vim.g["ctrlsf_position"] = "right"
  end,
}

return spec
