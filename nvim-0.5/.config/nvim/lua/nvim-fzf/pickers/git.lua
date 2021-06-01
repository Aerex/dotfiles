local fzf = require('fzf').fzf
local action = require('fzf.actions').action

local function get_git_file_path(file_name)
  local root = vim.split(vim.fn.system('git rev-parse --show-toplevel'), '\n')[1]
  return root .. '/' .. file_name
end


coroutine.wrap(function()
  local preview_files = action(function(lines)
    local file = lines[1]
    local file_path = get_git_file_path(file)
    local cmd = "bat --style=numbers --color always " .. vim.fn.shellescape(file_path)

    return vim.fn.system(cmd)
  end)

  local result = fzf('git ls-files --full-name --cached --others --exclude-standard',
    '--multi --ansi --expect=ctrl-v,ctrl-x,enter,ctrl-t --preview ' .. preview_files .. ' --prompt="GitFiles>"')
  local key = result[1]
  if key == '' or key == 'enter' then
    vimcmd = "e"
  elseif key == 'ctrl-x' then
    vimcmd = 'new'
  elseif key == 'ctrl-v' then
    vimcmd = 'vnew'
  elseif key == 'ctrl-t' then
    vimcmd = 'tabnew'
  else
    vimcmd = 'e'
  end
  for i=2,#result do
    vim.cmd(vimcmd .. ' ' .. vim.fn.fnameescape(get_git_file_path(result[i])))
  end
end)()
