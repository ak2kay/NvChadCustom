local M = {
  "dnlhc/glance.nvim",
  init = function()
    require("core.utils").load_mappings "glance"
  end,
  event = "BufRead",
}

function M.config()
  local glance = require "glance"

  local actions = glance.actions
  glance.setup {
    border = {
      enable = true, -- Show window borders. Only horizontal borders allowed
      top_char = "―",
      bottom_char = "―",
    },
    mappings = {
      list = {
        ["<leader>p"] = actions.enter_win "preview", -- Focus preview window
      },
    },
    hooks = {
      before_open = function(results, open, jump, method)
        local uri = vim.uri_from_bufnr(0)
        if #results == 1 then
          local target_uri = results[1].uri or results[1].targetUri

          if target_uri == uri then
            jump(results[1])
          else
            open(results)
          end
        else
          open(results)
        end
      end,
    },
  }
end

return M
