-- Credits to https://github.com/vijaymarupudi/nvim-fzf-commands/blob/master/lua/fzf-commands/rg.lua
require('fzf').default_window_options = {
  window_on_create = function()
    vim.cmd('set winhl=Normal:Normal')
  end
}
local action = require "fzf.actions".action
local fzf = require('fzf').fzf
local utils = require('nvim-fzf.utils')

local function open_file(window_cmd, filename, row, col)
  vim.cmd(window_cmd .. " ".. vim.fn.fnameescape(filename))
  vim.api.nvim_win_set_cursor(0, {row, col - 1})
  -- center the window
  vim.cmd "normal! zz"
end

local has_bat = vim.fn.executable("bat")

local preview_action = action(function (lines, fzf_lines)
  fzf_lines = tonumber(fzf_lines)
  local line = lines[1]
  local parsed = utils.parse_vimgrep_line(line)
  if has_bat then
    return utils.bat_preview(parsed, fzf_lines)
  else
    return utils.head_tail_preview(parsed, fzf_lines)
  end
end)

return function(pattern)
  coroutine.wrap(function ()
    local workspace = vim.lsp.buf.list_workspace_folders()[1]
    local rgcmd = "rg --vimgrep --no-heading " ..
      "--color ansi ".. vim.fn.shellescape(pattern or ' ')
      -- TODO: Need to process the result from rg to shorten filepath before printing into fzf
      -- There should be a method to do that in the library
--    if workspace then
--      rgcmd = rgcmd .. " -g '!.git/' " .. workspace
--    end
    local choices = fzf(rgcmd, "--multi --ansi --expect=ctrl-t,ctrl-s,ctrl-x,ctrl-v " .. "--preview " .. preview_action)
    if not choices then return end

    local window_cmd

    if choices[1] == "" then
      window_cmd = "e"
    elseif choices[1] == "ctrl-v" then
      window_cmd = "vsp"
    elseif choices[1] == "ctrl-t" then
      window_cmd = "tabnew"
    elseif choices[1] == "ctrl-x" or choices[1] == "ctrl-s" then
      window_cmd = "sp"
    end

    for i=2,#choices do
      local choice = choices[i]
      local parsed_content = utils.parse_vimgrep_line(choice)
      open_file(window_cmd,
        parsed_content.filename,
        parsed_content.row,
        parsed_content.col)
    end
  end)()
end
