local M = {}

M.parse_vimgrep_line = function (line)
  local parsed_content = {string.match(line, "(.-):(%d+):(%d+):(.*)")}
  local filename = parsed_content[1]
  local row = tonumber(parsed_content[2])
  local col = tonumber(parsed_content[3])
  local content = parsed_content[4]
  return {
    filename = filename,
    row = row,
    col = col,
    content = content,
  }
end

M.split_string = function(str, del)
  local list = {}
  for char in str:gmatch(del) do
   table.insert(list, char)
  end
  return list
end

M.slice_table = function(tbl, start, last)
  local new_t = {}
  for i=start,last,1 do
    table.insert(new_t, tbl[i])
  end
  return new_t
end

M.get_preview_line_range = function(parsed, fzf_lines)
  local line_start = parsed.row - (fzf_lines / 2)
  if line_start < 1 then
    line_start = 1
  else
    line_start = math.floor(line_start)
  end

  -- the minus one prevents an off by one error, because these are line INCLUSIVE
  local line_end = math.floor(parsed.row + (fzf_lines / 2)) - 1

  return line_start, line_end
end

M.bat_preview = function(parsed, fzf_lines, mem_path)
  local filename = mem_path[parsed.filename] or parsed.filename
  local line_start, line_end = M.get_preview_line_range(parsed, fzf_lines)
  local cmd = "bat --style=numbers --color always " .. vim.fn.shellescape(filename) ..
    " --highlight-line " .. tostring(parsed.row) ..
    " --line-range " .. tostring(line_start) .. ":" .. tostring(line_end)
  return vim.fn.system(cmd)
end

M.open_file = function(window_cmd, filename, row, col)
  vim.cmd(window_cmd .. " ".. vim.fn.fnameescape(filename))
  vim.api.nvim_win_set_cursor(0, {row, col - 1})
  -- center the window
  vim.cmd "normal! zz"
end

M.head_tail_preview = function(parsed, fzf_lines, mem_path)
  local filename = mem_path[parsed.filename] or parsed.filename
  local line_start, line_end = M.get_preview_line_range(parsed, fzf_lines)
  local output =  vim.fn.systemlist("tail --lines=+" .. tostring(line_start) .. " " .. vim.fn.shellescape(filename) ..
    "| head -n " .. tostring(line_end - line_start))

  local row_index = parsed.row - (line_start - 1)
  output[row_index] = "\x1B[1m\x1B[30m\x1B[47m" .. output[row_index] .. "\x1B[0m"
  return output
end

return M
