-- Credits to https://github.com/vijaymarupudi/nvim-fzf-commands/blob/master/lua/fzf-commands/helptags.lua
require('fzf').default_window_options = {
  window_on_create = function()
    vim.cmd('set winhl=Normal:Normal')
  end
}
local uv = vim.loop
local fzf = require('fzf').fzf

local function readfilecb(path, callback)
  uv.fs_open(path, 'r', 438, function(err, fd)
    if err then
      callback(err)
      return
    end
    uv.fs_fstat(fd, function(_, stat)
      if err then
        callback(err)
        return
      end
      uv.fs_read(fd, stat.size, 0, function(_, data)
        if err then
          callback(err)
          return
        end
        uv.fs_close(fd, function(err_fs_close)
          if err_fs_close then
            callback(err_fs_close)
            return
          end
          return callback(nil, data)
        end)
      end)
    end)
  end)
end

local function readfile(name)
  local co = coroutine.running()
  readfilecb(name, function (err, data)
    coroutine.resume(co, err, data)
  end)
  local err, data = coroutine.yield()
  if err then error(err) end
  return data
end

local function deal_with_tags(tagfile, cb)
  local co = coroutine.running()
  coroutine.wrap(function ()
    local success, data = pcall(readfile, tagfile)
    if success then
      for i, line in ipairs(vim.split(data, "\n")) do
        local items = vim.split(line, "\t")
        -- escape codes for grey
        local tag = string.format("%s\t\27[0;37m%s\27[0m", items[1], items[2])
        local co = coroutine.running()
        cb(tag, function ()
          coroutine.resume(co)
        end)
        coroutine.yield()
      end
    end
    coroutine.resume(co)
  end)()
  coroutine.yield()
end

local get_help_docs = function (cb)
      local runtimepaths = vim.api.nvim_list_runtime_paths()
      local total_done = 0
      for _, rtp in ipairs(runtimepaths) do
        local tagfile = table.concat({rtp, "doc", "tags"}, "/")
        -- wrapping to make all the file reading concurrent
        coroutine.wrap(function ()
          deal_with_tags(tagfile, cb)
          total_done = total_done + 1
          if total_done == #runtimepaths then
            cb(nil)
          end
        end)()
      end
    -- cb(nil)
  end

return function()
  coroutine.wrap(function ()
    -- TODO: Add a preview
      local choices = fzf(get_help_docs, '--nth 1 --ansi --expect=ctrl-t,ctrl-s,ctrl-v')
      local choice = vim.split(choices[2], '\t')[1]
      local key = choices[1]
      local windowcmd = ''
      if key == 'ctrl-v' then
        windowcmd = 'vertical'
      elseif key == 'ctrl-t' then
        windowcmd = 'tab'
      end

      vim.cmd(string.format('%s h %s', windowcmd, choice))
  end)()
end
