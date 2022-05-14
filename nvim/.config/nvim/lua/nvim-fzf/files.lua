-- Credits to https://github.com/vijaymarupudi/nvim-fzf-commands/blob/master/lua/fzf-commands/files.lua
require('fzf').default_window_options = {
  window_on_create = function()
    vim.cmd('set winhl=Normal:Normal')
  end
}

local action = require('fzf.actions').action
local cmd_line_trans = require('fzf.helpers').cmd_line_transformer
local fzf = require('fzf').fzf
local FZF_CACHE_FILES_DIR = vim.fn.stdpath('cache') .. '/fzf_files/'
local cache_file = ''
local filepath_map = {}

local preview_files = action(function(lines)
  -- using expand at this point will return the expand file path as `term::<path>:/port/usr/bin`
  -- so we will use regex to pull out the path only to build the true file path
  local file_path = filepath_map[lines[1]]
  local preview_cmd = vim.fn.executable('bat') == 1 and 'bat' or 'cat'
  local preview_opts = vim.fn.executable('bat') == 1 and '--style=numbers --color always' or ''
  local cmd = string.format('%s %s %s', preview_cmd, preview_opts, file_path)

  return vim.fn.system(cmd)
end)

local _ = {}

 _.find_files = function()
  cache_file = FZF_CACHE_FILES_DIR .. vim.fn.sha256(current_dir)
  local current_dir = vim.fn.expand('%:p:h')
  local find_cmd = vim.fn.executable('fd') == 1 and 'fd' or 'find'
  local find_opts = vim.fn.executable('fd') == 1 and string.format('-t f -L . %s', current_dir) or "-L -type f -print"
  local command = ''
  if vim.fn.filereadable(cache_file) == 0 then
    if vim.fn.isdirectory(FZF_CACHE_FILES_DIR) == 0  then
      vim.fn.mkdir(FZF_CACHE_FILES_DIR)
    end
    command = string.format('%s %s | tee ', find_cmd, find_opts) .. cache_file
  else
  command = string.format('cat %s ', cache_file)
  end
  local cmdchoices = cmd_line_trans(command, function(line)
    local path_parts = vim.split(line, '/')
    local filename = ''
    if #path_parts > 0 then
      filename = path_parts[#path_parts]
    end
      -- save ref to full filepath using filename as key
      filepath_map[filename] = line

      return filename
  end)
  coroutine.wrap(function ()
    local choices = fzf(cmdchoices, '--multi --ansi --expect=ctrl-v,ctrl-r,ctrl-t,ctrl-s,ctrl-x --preview '
      .. preview_files .. ' --prompt="Files> "', {
   })
    local vimcmd = 'e'
    local key = choices[1]
    if key == 'ctrl-x' or key == 'ctrl-s' then
      vimcmd = 'split'
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
      vim.cmd(string.format('%s %s', vimcmd, filepath_map[choices[i]]))
    end
  end)()
end
return _.find_files

