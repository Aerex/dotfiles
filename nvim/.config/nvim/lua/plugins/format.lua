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
  },
  {
    'dhruvasagar/vim-table-mode',
    cmd = { 'TableModeToggle', 'TableModeEnable', 'TableModeDisable', 'Tabelize', 'TableModeRealign' },
    config = function()
      vim.table_mode_auto_align = 1
    end
  }
}
