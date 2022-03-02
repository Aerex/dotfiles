local M = {}
M.setup = function()
  local hl_cfg = {
    LineNr = { fg = "#7a966c" },
    Label = { fg = "#cec6cc"},
    SpellBad = { bg = "None"},
    Comment = { gui = "bold", fg="#4C566A"},
    TSComment = { gui = "bold", fg="#4C566A"},
    Folded = { bg = "#4c566a", fg="black"},
    GitGutterAdd = { fg="#4ca64c "},
    SpellBad = { fg="#FF0000"}
  }

  local ok, lcfg = pcall(require, 'nvim-local')
  if ok then
    custom_hl_config = vim.tbl_deep_extend("force", hl_cfg, lcfg.get_hl_config())
  else
    custom_hl_config = hl_cfg
  end
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
    custom_highlights = custom_hl_config
  })
  vim.cmd [[ colorscheme onenord ]]
  vim.cmd('hi rainbowcol7 guifg=#D8DEE9')
  vim.cmd[[hi GitSignAdd guifg=#4ca64c guibg=none]]
  vim.cmd[[hi DiffAdd guifg=#4ca64c guibg=none]]
  vim.cmd[[hi DiffAdded guifg=#4ca64c guibg=none]]
  vim.cmd[[hi DiffRemoved guifg=#BF616A guibg=none]]
  vim.cmd[[hi Folded guifg=#D8DEE9]]
  vim.cmd[[hi SignatureMarkText guifg=#ffa500]]
  vim.cmd[[hi LineNr guifg=None]]
  vim.cmd[[hi SignColumn guifg=None]]
end

return M
