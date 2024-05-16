local M = {}

M.yanky = function()
  require('yanky').setup({
    ring = {
      storage = 'sqlite',
      history_length = 100,
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 500,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  })
end

return M
