-- Credits to https://github.com/leisiji/fzf_utils/blob/634460ce779cbc5a55ed0b3a424612f1c5a0a316/lua/nvim_fzf_commands.lua
local action = require('fzf.actions').action
local fzf = require('fzf').fzf
local FZF_CAHCE_FILES_DIR = vim.fn.stdpath('cache') .. '/fzf_files/'
local cache_file = FZF_CAHCE_FILES_DIR .. vim.fn.sha256(vim.fn.getcwd())

local preview_files = action(function(lines)
  local file_path= string.format('%s/%s', vim.fn.getcwd(), lines[1])
  local preview_cmd = vim.fn.executable('bat') == 1 and 'bat' or 'cat'
  local preview_opts = vim.fn.executable('bat') == 1 and '--style=numbers --color always' or ''
  local cmd = string.format('%s %s %s', preview_cmd, preview_opts, file_path)

  return vim.fn.system(cmd)
end)
local _ = {}

 _.find_files = function()
  local find_cmd = vim.fn.executable('fd') == 1 and 'fd' or 'find'
  local find_opts = vim.fn.executable('fd') == 1 and '-t f -L' or "-L -type f -printf %P\\\\n"
  if vim.fn.filereadable(cache_file) == 0 then
    if vim.fn.isdirectory(FZF_CAHCE_FILES_DIR) == 0  then
      vim.fn.mkdir(FZF_CAHCE_FILES_DIR)
    end
  end
  local command  = string.format('%s %s | tee ', find_cmd, find_opts) .. cache_file
  coroutine.wrap(function ()
    local choices = fzf(command, '--multi --ansi --expect=ctrl-v,ctrl-r,ctrl-t,ctrl-s --preview ' .. preview_files .. ' --prompt="Files> "')
    local vimcmd = 'e'
    local key = choices[1]
    if key == 'ctrl-x' then
      vimcmd = 'new'
    elseif key ==  'ctrl-v' then
      vimcmd = 'vnew'
    elseif key == 'ctrl-t' then
      vimcmd = 'tabnew'
    elseif key == 'ctrl-r' then
      os.remove(cache_file)
      -- To call find_files within itself it must be in a table
      vim.schedule(_.find_files)
    end

    for i=2, #choices do
      vim.cmd(string.format('%s %s', vimcmd, choices[i]))
    end
  end)()
end
return _.find_files
