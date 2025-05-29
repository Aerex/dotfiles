-- slower to access vim.api direct
local api = vim.api
local autocmd = function(...)
  api.nvim_create_autocmd(...)
end

local augrp = function(...)
  api.nvim_create_augroup(...)
end

autocmd('FileType', {
  pattern = '{neotest-output},{lspinfo},{qf},{dap-repl},{man},{help},{fugitiveblame},{dap-float},{httpResult}',
  callback = function(args)
    vim.keymap.set('n', 'qq', function() api.nvim_win_close(0, true) end,
      { silent = true, buffer = args.buf })
    vim.keymap.set('n', '<space>z', function() api.nvim_win_close(0, true) end,
      { silent = true, buffer = args.buf })
  end
})

autocmd('VimResized', {
  pattern = '*',
  command = 'wincmd ='
})

autocmd('VimEnter', {
  pattern = '*',
  callback = function()
    vim.fn.system('kill -s SIGWINCH $PPID')
  end
})

autocmd('TermOpen', {
  pattern = '*toggleterm#*',
  callback = function()
    require'plugins.configs.core'.terminal.maps()
  end
})

local format_auto = augrp('format_auto', { clear = false })
autocmd('BufWritePost', {
  pattern = { '*.go' },
  group = format_auto,
  callback = function()
    vim.cmd [[Format]]
    -- FIXME: Issue with args 1-2 in lua format
    --local win_ids = vim.fn.win_findbuf(args.buf)
    --local end_line = vim.fn.line('$')
    --if #win_ids > 0 then
    --  end_line = vim.fn.lin('$', win_ids)
    --end
    --require('formatter.format').format({}, {}, 0, end_line, { write = true })
  end,
  desc = 'Autoformat on file on save'
})
})

autocmd('FileType', {
  pattern =
  '{lspinfo},{qf},{dap-repl},{dap-float},{neotest-output},{man},{help},{fugitiveblame},{dap-float},{httpResult}',
  callback = function(args)
    vim.keymap.set('n', 'qq', function() api.nvim_win_close(0, true) end,
      { silent = true, buffer = args.buf })
  end
})
