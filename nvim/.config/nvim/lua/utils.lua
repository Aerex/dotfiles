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
  local root_packer_path = vim.fn.stdpath('data') .. '/site/pack/packer'
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

M.ultisnips = {}

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
  M.send_keys('<C-r>=[UltiSnips#CursorMoved(), UltiSnips#ExpandSnippet()][1]<cr>', 'n')
end

M.ultisnips.can_expand_snippet = function()
  return vim.fn['UltiSnips#CanExpandSnippet']() == 1 and
      vim.fn.complete_info() ~= nil and
      vim.fn.complete_info()["selected"] == -1
end

M.get_filename = function(path)
  paths = vim.fn.split(path, '/')
  return paths[#paths]
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

M.autocmd = function(...)
  vim.api.nvim_create_autocmd(...)
end

M.get_workspace = function()
  local workspace = ''
  if #vim.lsp.buf.list_workspace_folders() > 0 then
    workspace = vim.lsp.buf.list_workspace_folders()[1]
  end
  workspace = vim.lsp.buf.list_workspace_folders()[1]
  return workspace ~= "" and workspace or (M.is_git_repo() and M.get_git_root_path() or vim.fn.getcwd())
end

M.is_git_repo = function()
  return vim.split(vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null'), '\n')[1] ~= ""
end

M.get_git_root_path = function()
  return vim.split(vim.fn.system('git rev-parse --show-toplevel'), '\n')[1]
end

M.symbol_map = {
  Text = '',
  Method = 'ƒ',
  Function = '',
  Constructor = '',
  Field = 'ﰠ',
  Variable = '',
  Class = '',
  Interface = 'ﰮ',
  Module = '',
  Property = '',
  Enum = '了',
  Keyword = '',
  Snippet = '﬌',
  Color = '',
  File = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  TypeParameter = ''
}

M.get_efm_configs = function()
  local configs = {
    markdown = 'pandoc -f markdown -t gfm -sp --tab-stop=4',
    rst = 'pandoc -f rst -t rst -s --columns=79',
    shfmt = 'shfmt -ci -s -bn'
  }
  local settings = {
    languages = {}
  }
  local filetypes = {}
  for ft, cmd in pairs(configs) do
    local exec = vim.split(' ', cmd)[1]
    if vim.fn.executable(exec) then
      settings.languages[cmd] = {
        formatCommand = cmd,
        formatStdin = true
      }
      table.insert(filetypes, ft)
    end
  end
  return settings, filetypes
end

M.goimports = function(timeout_ms)
  -- Credits to https://github.com/neovim/neovim/blob/release-0.5/runtime/lua/vim/lsp/handlers.lua#L113
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, 't', true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  -- See the implementation of the textDocument/codeAction callback
  -- (lua/vim/lsp/handler.lua) for how to do this properly.
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

M.get_local_cfgs = function(cfg, fn_name, args)
  local ok, lcfg = pcall(require, 'nvim-local')
  local cust_cfg = cfg
  if ok and lcfg[fn_name] then
    cust_cfg = vim.tbl_deep_extend("force", cfg, lcfg[fn_name](args))
  end
  return cust_cfg
end

return M
