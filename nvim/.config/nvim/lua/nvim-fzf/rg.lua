-- Credits to https://github.com/vijaymarupudi/nvim-fzf-commands/blob/master/lua/fzf-commands/rg.lua
require('fzf').default_window_options = {
  window_on_create = function()
    vim.cmd('set winhl=Normal:Normal')
  end
}
local action = require "fzf.actions".action
local fzf = require('fzf').fzf
local helpers = require('fzf.helpers')
local utils = require('nvim-fzf.utils')

local function open_file(window_cmd, filename, row, col)
  vim.cmd(window_cmd .. " ".. vim.fn.fnameescape(filename))
  vim.api.nvim_win_set_cursor(0, {row, col - 1})
  -- center the window
  vim.cmd "normal! zz"
end

local has_bat = vim.fn.executable("bat")
local mem_path = {}

local preview_action = action(function (lines, fzf_lines)
  fzf_lines = tonumber(fzf_lines)
  local line = lines[1]
  local parsed = utils.parse_vimgrep_line(line)
  if has_bat then
    return utils.bat_preview(parsed, fzf_lines, mem_path)
  else
    return utils.head_tail_preview(parsed, fzf_lines, mem_path)
  end
end)

return function(pattern)
  coroutine.wrap(function ()
    local workspace = vim.lsp.buf.list_workspace_folders()[1]
    local rgcmd = "rg --vimgrep --no-heading " ..
      "--color never ".. vim.fn.shellescape(pattern or ' ')
    if workspace then
      rgcmd = rgcmd .. " -g '!.git/' " .. workspace
    end
    print(rgcmd)
    local rgcmd_shorten_path = helpers.cmd_line_transformer(rgcmd, function(line)
      local parsed = utils.parse_vimgrep_line(line)
      local path_parts = utils.split_string(parsed.filename, "(.-)/")
      local path_too_long = #path_parts > 3 and true or false
      local pfilename = parsed.filename
      mem_path[pfilename] = parsed.filename
      if path_too_long then
        pfilename = table.concat(utils.slice_table(path_parts, #path_parts-2, #path_parts), '/')
        mem_path[pfilename] = parsed.filename
      else
      end
      local tbl = {}
      table.insert(tbl, pfilename)
      table.insert(tbl, parsed.row)
      table.insert(tbl, parsed.col)
      table.insert(tbl, parsed.content)
      return table.concat(tbl, ':')
    end)
    local choices = fzf(rgcmd_shorten_path, "--multi --ansi --expect=ctrl-t,ctrl-s,ctrl-x,ctrl-v " .. "--preview " .. preview_action)
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
        mem_path[parsed_content.filename],
        parsed_content.row,
        parsed_content.col)
    end
  end)()
end
