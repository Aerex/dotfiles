local M = {}

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.send_keys = function(key, mode)
  vim.api.nvim_feedkeys(M.t(key), mode, true)
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

-- Credits to https://github.com/quangnguyen30192/cmp-nvim-ultisnips/pull/10
-- Apparently checking backspace is not enough to check if we should move foward to the next entry
M.has_any_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.ultisnips = {  }

M.ultisnips.can_jump_backwards = function()
  return vim.fn['UltiSnips#CanJumpBackwards']() == 1
end

M.ultisnips.jump_backwards = function()
  M.send_keys('<C-R>=UltiSnips#JumpBackwards()<CR>', 'n')
end

M.ultisnips.can_jump_forward = function()
  return vim.fn['UltiSnips#CanJumpForwards']() == 1
end

M.ultisnips.jump_forward = function()
  M.send_keys('<ESC>:call UltiSnips#JumpForwards()<CR>', 'n')
end

M.ultisnips.expand_snippet = function()
    M.send_keys('<C-R>=UltiSnips#ExpandSnippet()<CR>', 'n')
end

M.ultisnips.can_expand_snippet = function()
   return vim.fn['UltiSnips#CanExpandSnippet']() == 1 and
    vim.fn.complete_info() ~= nil and
    vim.fn.complete_info()["selected"] == -1
end

return M
