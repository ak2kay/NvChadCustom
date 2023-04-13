local spec = {
  "dyng/ctrlsf.vim",
  cmd = { "CtrlSF" },
  keys = { [[<leader>rw]] },
  config = function()
    vim.g["ctrlsf_auto_focus"] = { at = "start" }
    vim.g["ctrlsf_position"] = "right"
  end,
}

return spec
