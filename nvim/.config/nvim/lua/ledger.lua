local ok, wk = pcall(require, 'which-key')
vim.g.cmp_hledger_file = '/home/aerex/Documents/repos/.private/ledger/main.journal'
if ok then
  wk.register({
    t = {
      name = "Transaction State",
      t = { function() vim.cmd(":call ledger#transaction_state_toggle(line('.'), ' *?!')") end, "Toggle State" },
      c = { function() vim.cmd(":call ledger#transaction_state_set(line('.'), '*')") end, "Clear Transaction"},
      p = { function() vim.cmd(":call ledger#transaction_state_set(line('.'), '!')") end, "Set Transaction to Pending"},
      u = { function() vim.cmd(":call ledger#transaction_state_set(line('.'), '?')") end, "Set Transaction to Unknown"},
      d = "which_key_ignore",
      n = "which_key_ignore",
      o = "which_key_ignore",
    }}, {
    buffer = 0,
    mode = 'n',
    silent = true,
    noremap = true,
    nowait = true,
    prefix = '<leader>'
  })
  wk.register({
      ["]"] = { "/^\\d<CR>", "Next Transaction"},
      ["["] = { "?^\\d<CR>", "Previous Transaction"}
  }, {
    buffer = 0,
    mode = 'n',
    silent = true,
    noremap = true,
    nowait = true,
    prefix = ''
  })
end
