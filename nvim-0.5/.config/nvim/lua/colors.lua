local M = {}
M.setup = function()
  vim.cmd [[ syntax enable ]]
  vim.cmd [[ syntax on ]]
  require('onenord').setup({
    borders = true, -- Split window borders
    italics = {
      comments = false, -- Italic comments
      strings = false, -- Italic strings
      keywords = true, -- Italic keywords
      functions = false, -- Italic functions
      variables = false, -- Italic variables
    },
    disable = {
      background = true, -- Disable setting the background color
      cursorline = false, -- Disable the cursorline
      eob_lines = true, -- Hide the end-of-buffer lines
    },
    custom_highlights = {
      LineNr = { fg = "#7a966c" },
      Label = { fg = "#cec6cc"},
      Comment = { gui = "bold"},
      TSComment = { gui = "bold"},
      Folded = { bg = "#4c566a", fg="black"}

    }, -- Overwrite default highlight groups
  })
  vim.cmd [[ colorscheme onenord ]]
end

return M
