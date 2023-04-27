local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- try to fix nvim overlapping in tmux
vim.cmd [[
  if &term =~ 'tmux'
      set t_ut=y
  endif
]]

-- better diff view, see: https://github.com/neovim/neovim/pull/14537
vim.cmd [[set diffopt+=linematch:50]]

local opt = vim.opt

-- no swap file warning!
opt.swapfile = false

opt.joinspaces = false -- No double spaces with join after a dot

opt.wildignorecase = true
opt.wildignore:append "**/node_modules/*"
opt.wildignore:append "**/.git/*"

opt.relativenumber = true --Make relative number default
