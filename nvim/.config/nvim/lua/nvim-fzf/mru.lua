-- Credits to https://raw.githubusercontent.com/leisiji/fzf_utils/0f91e448235ff91f793b178ba7d3bdc5e1d5cbf2/lua/fzf_utils/mru.lua
-- mru is stored at ~/.cache/nvim/fzf_mru
-- every accessed file path is stored at each line
local M = {}
local fn = vim.fn
local raw_fzf = require('fzf.actions').raw_async_action
local get_workspace = require('utils').get_workspace
local transform = require('fzf.helpers').cmd_line_transformer
local a = require('plenary.async_lib')
local uv = a.uv
local fzf_mru = {
  mtime = 0,
  cache = "",
  nums = 1024,
  lock = false,
  file = string.format('%s/%s', fn.stdpath('cache'), 'fzf_mru')
}

-- fzf_mru_mtime, fzf_mru_cache is for cache.
-- When 'fzf_mru' is modified in another vim, it should update the cache
local function add_file(f)
  a.async_void(function ()
    fzf_mru.lock = true
    local data
    local res = f .. '\n'
    local i, p = 1, 1
    local _, fd = a.await(uv.fs_open(fzf_mru.file, 'r+', 438))
    local _, stat = a.await(uv.fs_fstat(fd))
    local nums = 0

    if fzf_mru.mtime ~= stat.mtime.sec then
      _, data = a.await(uv.fs_read(fd, stat.size, 0))
    else
      data = fzf_mru.cache
    end

    while i <= #data do
      if string.sub(data, i, i) == '\n' then
        if string.sub(data, p, i - 1) == f then
          res = res .. string.sub(data, 1, p - 1) .. string.sub(data, i + 1, #data)
          break
        end
        p = i + 1
        nums = nums + 1
      end
      i = i + 1
    end

    -- if file not found in mru, then check nums and append
    if i > #data then
      if nums > fzf_mru.nums then
        local oversize = nums - fzf_mru.nums
        local j = #data
        while oversize > 0 do
          j = j - 1
          if string.sub(data, j, j) == '\n' then
            oversize = oversize - 1
          end
        end
        res = res .. string.sub(data, 1, j)
      else
        res = res .. data
      end
    end

    a.await(uv.fs_write(fd, res, 0))
    a.await(uv.fs_ftruncate(fd, #res))

    _, stat = a.await(uv.fs_fstat(fd))
    fzf_mru.cache = res
    fzf_mru.mtime = stat.mtime.sec
    a.await(uv.fs_close(fd))
    fzf_mru.lock = false
  end)()
end

function M.filter_mru(cmd)
    local workspace = get_workspace()
  return raw_fzf(function(pipe, args)
    if workspace ~= '' then
      workspace = vim.fn.getcwd()
    end
    wk_ptrn = string.format('^%s', workspace)
    if string.find(line, wk_ptrn) then
      return line
    end
  end)
end

function M.refresh_mru()
  if fzf_mru.lock then
    return
  end

  vim.defer_fn(function ()
    local f = fn.expand('%:p')
    if fn.filereadable(f) == 0 then
      return
    end

    if fn.filereadable(fzf_mru.file) == 0 then
      local file = io.open(fzf_mru.file, "a")
      io.close(file)
    end

    add_file(f)
  end, 500)

end

function M.get_mru()
  coroutine.wrap(function ()
    local print_file_cmd = vim.fn.executable('bat') and 'bat ' or 'cat '
    -- FIXME(me): Crashes when using --header opt flag
    local headers = 'ctrl-r=Refresh mru, ctrl-w=Show only files in workspace'
    local reload_cmd = string.format('--bind "ctrl-w:reload(%s)"', M.filter_mru)
    local choices = require('fzf').fzf(print_file_cmd .. fzf_mru.file, '--expect=ctrl-r,ctrl-v,ctrl-x,ctrl-s '.. reload_cmd)
    local key = choices[1]
    local vimcmd = 'e'
    if key == 'ctrl-r' then
      os.remove(fzf_mru.file)
      vim.schedule(M.fzf_mru)
    elseif key == 'ctrl-x' or key == 'ctrl-s' then
      vimcmd = 'split'
    elseif key == 'ctrl-t' then
      vimcmd = 'tabnew'
    elseif key == 'ctrl-v' then
      vimcmd = 'vnew'
    end

    for i=2,#choices do
      vim.cmd(vimcmd .. ' ' .. choices[2])
    end
  end)()
end

return M
