local fzf = require('fzf').fzf
local action = require('fzf.actions').action

return function()
  coroutine.wrap(function()
    local _ = {}
    _.get_git_root_path = function()
      return vim.split(vim.fn.system('git rev-parse --show-toplevel'), '\n')[1]
    end


    local preview_files = action(function(lines)
      local root = _.get_git_root_path()
      local file_path= string.format('%s/%s', root,lines[1])
      local cmd = "bat --style=numbers --color always " .. vim.fn.shellescape(file_path)

      return vim.fn.system(cmd)
    end)

    local git_ls_files = 'git ls-files --full-name --cached --others --exclude-standard'
    local command = string.format('%s %s', git_ls_files, _.get_git_root_path())
    local result = fzf(command,
    '--multi --ansi --expect=ctrl-v,ctrl-x,enter,ctrl-t --preview ' .. preview_files .. ' --prompt="GitFiles> "')
    local key = result[1]

    local vimcmd = 'e'
    if key == 'ctrl-x' then
      vimcmd = 'new'
    elseif key == 'ctrl-v' then
      vimcmd = 'vnew'
    elseif key == 'ctrl-t' then
      vimcmd = 'tabnew'
    end

    for i=2,#result do
      vim.cmd(vimcmd .. ' ' .. vim.fn.fnameescape(_.get_git_file_path(result[i])))
    end

  end)()
end
