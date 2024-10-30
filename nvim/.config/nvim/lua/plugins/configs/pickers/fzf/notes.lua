require('fzf').default_window_options = {
  window_on_create = function()
    vim.cmd('set winhl=Normal:Normal')
  end
}

local fzf = require('fzf').fzf
local action = require "fzf.actions".action
local utils = require('plugins.configs.lsp.utils')

local has_bat = vim.fn.executable("bat")

local preview_action = action(function(lines, fzf_lines)
  fzf_lines = tonumber(fzf_lines)
  local line = lines[1]
  local parsed = utils.parse_vimgrep_line(line)
  if has_bat then
    return utils.bat_preview(parsed, fzf_lines)
  else
    return utils.head_tail_preview(parsed, fzf_lines)
  end
end)

return function(pattern, opts)
  coroutine.wrap(function()
    opts = opts or {}
    local notes_dir = opts.notes_dir or vim.fn.expand(vim.g.notes_dir)
    local rgcmd = "rg --follow --ignore-files --smart-case --line-number --color never " ..
        "--no-messages --no-heading --with-filename " .. vim.fn.shellescape(pattern or '') ..
        " " .. vim.fn.shellescape(notes_dir)
    local fzf_options = " --print-query --ansi --multi --info=inline --expect=ctrl-t,ctrl-s,ctrl-v " ..
        "--preview " .. preview_action
    local choices = fzf(rgcmd, fzf_options)
    if not choices then return end

    local window_cmd

    if choices[1] == "" then
      window_cmd = "e"
    elseif choices[1] == "ctrl-v" then
      window_cmd = "vsp"
    elseif choices[1] == "ctrl-t" then
      window_cmd = "tabnew"
    elseif choices[1] == "ctrl-x" then
      window_cmd = "sp"
    end

    for i = 2, #choices do
      local choice = choices[i]
      local parsed_content = utils.parse_vimgrep_line(choice)
      utils.open_file(window_cmd,
        parsed_content.filename,
        parsed_content.row,
        parsed_content.col)
    end
  end)()
end
