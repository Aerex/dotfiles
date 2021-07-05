-- Credits to https://github.com/bfredl/nvim-miniyank/blob/master/lua/miniyank.lua

local message_pack = require('MessagePack')
message_pack.set_string('binary')

require('fzf').default_window_options = {
  window_on_create = function()
    vim.cmd('set winhl=Normal:Normal')
  end
}
local fzf = require('fzf').fzf

return function()
  coroutine.wrap(function()
    local _ = {}
    _.get_history = function()
      local file = io.open(vim.g.miniyank_filename, 'rb')
      local data = file:read('*all')
      local entries = {}
      for _, item in message_pack.unpacker(data) do
        local key = vim.trim(item[1][1])
        -- exclude empty content in registers
        if key ~= '' and key ~= ' ' then
          entries[key] = item
        end
      end
      file:close()
      return entries
    end

    local history = _.get_history()
    local choices = fzf(vim.tbl_keys(history), "--prompt='MiniYank> ' --expect=enter,alt-enter")
    local cmd = choices[1]

    local vimcmd = 'p'
    if cmd == 'enter' then
      vimcmd = 'p'
    elseif cmd == 'alt-enter' then
      vimcmd = 'P'
    end

    local entry = history[choices[2]]
    print(vim.inspect(entry))
    ---- retrieve current  content in 0 registe
    local current_reg_content = vim.fn.getreg('0')
    local current_reg_type = vim.fn.getregtype('0')
    ---- yank to 0 register
    vim.fn.setreg('0', entry[1][1], entry[2])
    ---- paste 0 register
    vim.cmd(string.format('normal! "0%s', vimcmd))
    ---- restore original
    vim.fn.setreg('0', current_reg_content, current_reg_type)
  end)()
end
