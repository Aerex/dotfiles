local api = vim.api
local b = vim.b
local exists = vim.fn.exists
local M = {}
function M.toggle_signs()
  if exists('b:gitsigns_head') then
    require'gitsigns'.detach()
    api.nvim_command('echo "Disabled GitSigns"')
  else
    require'gitsigns'.attach()
    require'gitsigns'.refresh()
    api.nvim_command('echo "Enabled GitSigns"')
  end
end
function M.setup()
  require'gitsigns'.setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '+'},
      change       = {hl = 'GitSignsChange', text = '│'},
      delete       = {hl = 'GitSignsDelete', text = '_'},
      topdelete    = {hl = 'GitSignsDelete', text = '‾'},
      changedelete = {hl = 'GitSignsChange', text = '~'},
    },
    numhl = false,
    linehl = false,
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,

      ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
      ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

      ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
      ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
      ['n <leader>ht'] = '<cmd>lua require"gitsigns".toggle_signs()<CR>',

      -- Text objects
      ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
      ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>'
    },
    watch_index = {
      interval = 100
    },
    sign_priority = 100,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    use_decoration_api = true,
    use_internal_diff = false,  -- If luajit is present
  }
  api.nvim_command("hi! GitSignsAdd ctermfg=193 ctermbg=236 guifg=#333333 guibg=#D2EBBE")
  api.nvim_command("hi! GitSignsChange ctermbg=236 guibg=#333333")
end

return M
