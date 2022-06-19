local M = {}

-- Convert UTF-8 hex code to character
M.u = function(code)
    if type(code) == 'string' then code = tonumber('0x' .. code) end
    local c = string.char
    if code <= 0x7f then return c(code) end
    local t = {}
    if code <= 0x07ff then
        t[1] = c(bit.bor(0xc0, bit.rshift(code, 6)))
        t[2] = c(bit.bor(0x80, bit.band(code, 0x3f)))
    elseif code <= 0xffff then
        t[1] = c(bit.bor(0xe0, bit.rshift(code, 12)))
        t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
        t[3] = c(bit.bor(0x80, bit.band(code, 0x3f)))
    else
        t[1] = c(bit.bor(0xf0, bit.rshift(code, 18)))
        t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 12), 0x3f)))
        t[3] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
        t[4] = c(bit.bor(0x80, bit.band(code, 0x3f)))
    end
    return table.concat(t)
end

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
  M.send_keys('<ESC>: call UltiSnips#JumpBackwards()<CR>', 'n')
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

M.toggle_max_window = function()
  local win = vim.api.nvim_win_get_buf(0)
  local max_win = vim.api.nvim_win_get_var(win, 'c_max_win')
  if max_win == nil then
    -- TODO(me): See if there is any api call to max resize windows
    vim.cmd('resize')
    vim.cmd('vertical resize')
    vim.api.nvim_win_set_var(win, 'c_max_win', 1)
  else
    -- TODO(me): See if there is any api call to balance windows
    M.send_keys('<C-w>=', 'n')
    vim.api.nvim_win_set_var(win, 'c_max_win', nil)
  end
end

return M
