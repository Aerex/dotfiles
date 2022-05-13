local M = {}
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
    languages = { }
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
  return  settings, filetypes
end

M.goimports = function(timeout_ms)
  -- Credits to https://github.com/neovim/neovim/blob/release-0.5/runtime/lua/vim/lsp/handlers.lua#L113
  local context = {source = {organizeImports = true}}
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

--vim.lsp.handlers["textDocument/definition"] = goto_definition('split')
--M.get_system_name = function()
--  local system_name
--  if vim.fn.has("mac") == 1 then
--    system_name = "macOS"
--  elseif vim.fn.has("unix") == 1 then
--    system_name = "Linux"
--  elseif vim.fn.has('win32') == 1 then
--    system_name = "Windows"
--  else
--    print("Unsupported system for sumneko")
--  end
--  return system_name
--end
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
--M.sumneko_root_path = vim.fn.stdpath('cache') .. '/lspconfig/sumneko_lua/lua-language-server'
--local sumneko_binary = sumneko_root_path..'/bin/'..system_name..'/lua-language-server'
--M.sumneko_binary = M.sumneko_root_path .. '/bin/Linux/lua-language-server'

return M
