return {
  { 'sbdchd/neoformat' },
  { 'godlygeek/tabular', cmd = { 'Tabularize' } },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        char = '|',
        buftype_exclude = { 'terminal' },
        filetype_exclude = { 'ledger', 'help' }
      }
    end
  }
}
