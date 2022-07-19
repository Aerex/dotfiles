local fzf = require('fzf')
local fzf_cli = fzf.fzf
local uv = vim.loop

fzf.default_window_options = {
  window_on_create = function()
    vim.cmd('setlocal winhl=Normal:Normal,NormalFloat:Normal,FloatBorder:Normal')
  end
}

fzf.default_options = {
  border =  'single',
  relative = 'editor',
  style = 'minimal'
}
local action = require('fzf.actions').async_action

return function()
  coroutine.wrap(function()
    local _ = {}
    _.get_git_root_path = function()
      return vim.split(vim.fn.system('git rev-parse --show-toplevel'), '\n')[1]
    end
    _.is_git_repo = function()
      return vim.split(vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null'), '\n')[1] ~= ""
    end

    _.get_git_full_file_path = function(file_name)
      return string.format('%s/%s', _.get_git_root_path(), file_name)
    end

    if not _.is_git_repo then
      return
    end


    local preview_files = action(function(pipe, lines)
      local root = _.get_git_root_path()
      local file_path= string.format('%s/%s', root,lines[1])
      local cmd = "bat --style=numbers --color always " .. vim.fn.shellescape(file_path)
      uv.write(pipe, vim.fn.system(cmd), function()
        uv.close(pipe)
      end)
    end)

    local git_ls_files = 'git ls-files --full-name --cached --others --exclude-standard'
    local command = string.format('%s %s', git_ls_files, _.get_git_root_path())
    local result = fzf_cli(command,
    '--multi --expect=ctrl-v,ctrl-x,ctrl-s,enter,ctrl-t --preview ' .. preview_files .. ' --prompt="GitFiles> "')
    local key = result[1]

    local vimcmd = 'e'
    if key == 'ctrl-x' or key == 'ctrl-s' then
      vimcmd = 'split'
    elseif key == 'ctrl-v' then
      vimcmd = 'vnew'
    elseif key == 'ctrl-t' then
      vimcmd = 'tabnew'
    end

    for i=2,#result do
      vim.cmd(vimcmd .. ' ' .. vim.fn.fnameescape(_.get_git_full_file_path(result[i])))
    end
  end)()
end
