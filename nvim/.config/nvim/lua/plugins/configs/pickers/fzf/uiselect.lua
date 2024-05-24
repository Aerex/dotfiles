require('fzf').default_window_options = {
  window_on_create = function()
    vim.cmd('set winhl=Normal:Normal')
  end
}
local action = require('fzf.actions').action
local utils = require('nvim-fzf.utils')
local fzf = require('fzf').fzf


return function(items, opts, on_choice)
  local prompt = opts.prompt
  if not prompt then
      prompt =  'Select:'
  end

  local entries = {}
  for i, e in ipairs(items) do
    table.insert(entries, ("%s. %s"):format(tostring(i),
        opts.format_item and opts.format_item(e) or tostring(e)))
  end


  -- wrap in quotes
  prompt = string.format('"%s> "', prompt)

  coroutine.wrap(function ()
    local choices = fzf(entries, '--preview-window "hidden:right:0" --no-multi --ansi '
    .. ' --prompt=' .. prompt)
    local selected = choices[1]

    -- Credits: https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/providers/ui_select.lua#L101
    -- use regex to search for index on selection
    local idx = selected and tonumber(selected:match("^(%d+).")) or nil
    local item = idx and items[idx] or nil

    -- run callback
    on_choice(item, tonumber(idx))
  end)()
end
