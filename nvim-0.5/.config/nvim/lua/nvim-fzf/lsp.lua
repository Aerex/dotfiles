local fzf = require('fzf').fzf
local M = {}

M.document_symbols = function()
  coroutine.wrap(function()
    local lsp_results = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbol', vim.lsp.util.make_position_params(), 10000)
    if not lsp_results or vim.tbl_isempty(lsp_results) then return end
    local items_by_name = {}
    for _, lsp_result in pairs(lsp_results) do
      local items = vim.lsp.util.symbols_to_items(lsp_result.result,0)
      for _, item in pairs(items) do
        items_by_name[item.text] = item
      end
    end

    -- TODO: figure out who you need to do an inline import here. Doesn't work otherwise
    local preview_files = require('fzf.actions').action(function(lines, fzf_lines)
      local item = items_by_name[lines[1]]

      local start_line = item.lnum - (fzf_lines / 2)
      start_line = start_line < 0 and 0 or start_line
      local end_line = item.lnum + (fzf_lines / 2)

      local preview_cmd = string.format('cat %s', item.filename)
      if vim.fn.executable('bat') then
        preview_cmd = string.format('bat -H %d --style numbers --color always -r %i:%i %s',
          item.lnum, start_line, end_line, item.filename)
      end

     return vim.fn.system(preview_cmd)
    end)

    local choices = fzf(vim.tbl_keys(items_by_name),
     '--ansi --expect=ctrl-v,ctrl-x,enter,ctrl-t --preview ' .. preview_files .. ' --prompt="Document Symbols> "')
     local vimcmd = 'e'
     local key = choices[1]
     if key == 'ctrl-x' then
       vimcmd = 'new'
     elseif key ==  'ctrl-v' then
       vimcmd = 'vnew'
     elseif key == 'ctrl-t' then
       vimcmd = 'tabnew'
     end

     for i=2, #choices do
       local item = items_by_name[choices[i]]
       vim.cmd(string.format('%s +%s %s', vimcmd, item.lnum, item.filename))
     end
  end)()
end

return M
