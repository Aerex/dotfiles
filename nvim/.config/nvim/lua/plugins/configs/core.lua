local M        = {}

M.yanky        = function()
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

local toggleterm_exists, _ = pcall(require, 'toggleterm')
if toggleterm_exists then
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit  = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

  M.terminal     = {
    lazygit_toggle = function()
      if vim.fn.executable('lazygit') then
        lazygit:toggle()
      else
        print("lazygit is not installed")
      end
    end,
    set_terminal_keymaps = function()
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
    end
  }
end


M.bqf = {
  setup = function()
    require('bqf').setup({
      auto_enable = true,
      auto_resize_height = true, -- highly recommended enable
      preview = {
        auto_preview = true,
        border = 'rounded',
        winblend = 12,
        wrap = false,
        buf_label = true,
        show_title = true,
        show_scroll_bar = true,
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match('^fugitive://') then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end
      },
    -- make `drop` and `tab drop` to become preferred
    func_map = {
        drop = 'o',
        openc = 'O',
        split = '<C-s>',
        tabdrop = '<C-t>',
        tabc = '',
        ptogglemode = 'z,',
    },
    filter = {
        fzf = {
            action_for = {['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop'},
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
        }
    }
})
  end
}
return M
