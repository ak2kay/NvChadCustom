---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "ashes",
  theme_toggle = { "ashes", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  statusline = {
    overriden_modules = function()
      local sep_style = vim.g.statusline_sep_style
      local separators = (type(sep_style) == "table" and sep_style) or { left = "", right = " " }
      local sep_r = separators["right"]

      local function nvim_navic()
        local navic = require "nvim-navic"
        if navic.is_available() then
          return navic.get_location()
        else
          return ""
        end
      end

      return {
        fileInfo = function()
          local icon = "  "
          local filename = (vim.fn.expand "%" == "" and "Empty ") or vim.fn.expand "%:~:."

          if filename ~= "Empty " then
            local devicons_present, devicons = pcall(require, "nvim-web-devicons")

            if devicons_present then
              local ft_icon = devicons.get_icon(filename)
              icon = (ft_icon ~= nil and " " .. ft_icon) or ""
            end

            filename = " " .. filename .. " "
          end

          return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
        end,
        -- override default lsp progress component of nvchad, we use fidget.nvim instead.
        LSP_progress = function()
          if rawget(vim, "lsp") then
            return "%#Nvim_navic#" .. nvim_navic()
          else
            return ""
          end
        end,
      }
    end,
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
