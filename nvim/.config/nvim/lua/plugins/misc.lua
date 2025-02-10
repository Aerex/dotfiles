return {
  {
    'NTBBloodbath/rest.nvim',
    ft = { 'http' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      config = function()
        require 'plugins.configs.misc'
      end
    }
  },
  {
      'folke/which-key.nvim',
       config = function()
        require 'plugins.configs.misc'.which_key.setup()
      end,
      event = 'VeryLazy',
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          '<leader>?',
          function()
            require('which-key').show({ global = false })
          end,
          desc = 'Buffer Local Keymaps (which-key)',
        },
      },
  },
  {
    'serenevoid/kiwi.nvim',
    lazy = true
  },
  {
    'vimwiki/vimwiki',
    ft = { 'vimwiki', 'markdown' },
    setup = function()
      vim.g.vimwiki_key_mappings = { headers = 0, html = 0, global = 0, links = 0 }
    end
  },
  {
    'voldikss/vim-translator',
    cmd = { 'Translate', 'TranslateR', 'TranslateW', 'TranslateL' },
    ft = { 'trans' }
  },
  {
    'ledger/vim-ledger',
    ft = { 'ledger' },
    config = function()
      require 'ledger'
    end
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    ft = { 'markdown' },
  },
  {
    'sunaku/vim-dasht',
    config = function()
      vim.g.dasht_filetype_docsets = {
        typescript = { 'Mocha', 'Sinon' },
        javascript = { 'Mocha', 'Sinon' }
      }
    end
  }
}
