local M = {}
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
M.setup = function()
  require("formatter").setup {
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
      -- Formatter configurations for filetype "lua" go here
      -- and will be executed in order
      go = {
        -- "formatter.filetypes.lua" defines default configurations for the
        -- "lua" filetype
        require("formatter.filetypes.go").goimports,
        require("formatter.filetypes.go").gofmt,
      },
      json = {
        require('formatter.filetypes.json').jq
      },
      python = {
        require('formatter.filetypes.python').autopep8
      },
      -- Use the special "*" filetype for defining formatter configurations on
      -- any filetype
      ["*"] = {
        -- "formatter.filetypes.any" defines default configurations for any
        -- filetype
        require("formatter.filetypes.any").remove_trailing_whitespace
      }
    }
  }
end

return M
