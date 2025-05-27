return {
  { 'mhartington/formatter.nvim',
    config = function()
      require('formatter').setup{
      logging = true,
      filetype = {
        json = {
          require('formatter.filetypes.json').jq
        },
        go = {
          require('formatter.filetypes.go').gofmt
        }
      }
    }
    end
  },
  { 'godlygeek/tabular',         cmd = { 'Tabularize' } },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('ibl').setup({
        indent = { char = '|' },
        exclude = { buftypes = { 'terminal' }, filetypes = { 'ledger', 'help' } }
      })
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
