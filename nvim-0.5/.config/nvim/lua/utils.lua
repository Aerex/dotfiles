local M = {}

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.get_packer_path = function()
  local root_packer_path =  vim.fn.stdpath('data') .. '/site/pack/packer'
  return {
    opt = root_packer_path .. '/opt',
    start = root_packer_path .. '/start'
  }
end

M.check_back_space = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col == 0 or vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    :sub(col, col)
    :match("%s") ~= nil
end

M.send_keys = function(key, mode)
  vim.api.nvim_feedkeys(M.t(key), mode, true)
end

M.ultisnips = {  }

M.ultisnips.can_jump_backwards = function()
  return vim.fn['UltiSnips#CanJumpBackwards']() == 1
end

M.ultisnips.jump_backwards = function()
  M.send_keys('<C-R>=UltiSnips#JumpBackwards()<CR>')
end

M.ultisnips.can_jump_forward = function()
  return vim.fn['UltiSnips#CanJumpForwards']() == 1
end

M.ultisnips.jump_forward = function()
  M.send_keys('<ESC>:call UltiSnips#JumpForwards()<CR>')
end

M.ultisnips.expand_snippet = function()
  vim.api.nvim_feedkeys(M.t('<C-R>=UltiSnips#ExpandSnippet()<CR>'))
end

M.ultisnips.can_expand_snippet = function()
   return vim.fn['UltiSnips#CanExpandSnippet']() == 1
end

return M
