-- Credits to https://github.com/vijaymarupudi/nvim-fzf-commands/blob/master/lua/fzf-commands/manpicker.lua
require('fzf').default_window_options = {
  window_on_create = function()
    vim.cmd('set winhl=Normal:Normal')
  end
}
local action = require('fzf.actions').action
local fzf = require('fzf').fzf

return function()
  coroutine.wrap(function (options)
    local choices = fzf('man -k .', '--tiebreak begin --nth 1,2 --expect=ctrl-v,ctrl-s,ctrl-x,ctrl-t --prompt="Man> "')
    if choices then
      local vimcmd = ''
      local key = choices[1]
      if key == 'ctrl-x' or key == 'ctrl-s' then
        vimcmd = ''
      elseif key ==  'ctrl-v' then
        vimcmd = 'vsplit |'
      elseif key == 'ctrl-t' then
        vimcmd = 'tab |'
      end

      local split_items = {}
      local manpagename = nil
      local chapter = ''
      for i=2, #choices do
        split_items = vim.split(choices[i], ' ')
        manpagename = split_items[1]
        chapter = string.match(split_items[2], '%((.+)%)')
        local man_cmd = string.format('Man %s(%s)', manpagename, chapter)
        print(man_cmd)
        vim.cmd(string.format('%s %s', vimcmd, man_cmd))
      end
    end
  end)()
end
