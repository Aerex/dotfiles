local M = {}
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
