local M = {}
M.setup = function()
  local hl_cfg = {
    rainbowcol17      = { fg = "#D8DEE9" },
    LineNr            = { fg = "None" },
    Label             = { fg = "#cec6cc" },
    Comment           = { gui = "bold", fg = "#4C566A" },
    TSComment         = { gui = "bold", fg = "#4C566A" },
    Folded            = { fg = "#D8DEE9" },
    GitGutterAdd      = { fg = "#4ca64c" },
    FidgetTask        = { bg = "None" },
    GitSignAdd        = { fg = "#4ca64c" },
    DiffAdd           = { fg = "#4ca64c", bg = "None" },
    DiffAdded         = { fg = "#4ca64c", bg = "None" },
    DiffRemoved       = { fg = "#BF616A", bg = "None" },
    SpellBad          = { fg = "#FF0000" },
    SignatureMarkText = { fg = "#FFA500" },
    SignColumn        = { fg = "None" },
  }


  local ok, lcfg = pcall(require, 'nvim-local')
  local custom_hl_config
  if ok and lcfg['get_hl_config'] then
    custom_hl_config = vim.tbl_deep_extend('force', hl_cfg, lcfg.get_hl_config())
  else
    custom_hl_config = hl_cfg
  end
  require('onenord').setup({
    borders = true,      -- Split window borders
    italics = {
      comments = false,  -- Italic comments
      strings = false,   -- Italic strings
      keywords = true,   -- Italic keywords
      functions = false, -- Italic functions
      variables = false, -- Italic variables
    },
    disable = {
      background = true,  -- Disable setting the background color
      cursorline = false, -- Disable the cursorline
      eob_lines = true,   -- Hide the end-of-buffer lines
    },
    custom_highlights = custom_hl_config
  })
  vim.cmd [[ colorscheme onenord ]]
  vim.cmd('hi rainbowcol7 guifg=#D8DEE9')
  vim.cmd [[hi GitSignAdd guifg=#4ca64c guibg=none]]
  vim.cmd [[hi DiffAdd guifg=#4ca64c guibg=none]]
  vim.cmd [[hi DiffAdded guifg=#4ca64c guibg=none]]
  vim.cmd [[hi DiffRemoved guifg=#BF616A guibg=none]]
  vim.cmd [[hi Folded guifg=#D8DEE9]]
  vim.cmd [[hi SignatureMarkText guifg=#ffa500]]
  vim.cmd [[hi LineNr guifg=None]]
  vim.cmd [[hi SignColumn guifg=None]]
  vim.cmd([[
    hi BqfPreviewBorder guifg=#50a14f ctermfg=71
    hi link BqfPreviewRange Search
  ]])
end

return M
