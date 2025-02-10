return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'petertriho/cmp-git',
      'kirasok/cmp-hledger',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      {
        'davidsierradz/cmp-conventionalcommits',
        ft = { 'NeogitCommitMessage' }
      },
      'uga-rosa/cmp-dictionary',
      {
        lazy = true,
        'lukas-reineke/cmp-rg'
      },
      'hrsh7th/cmp-look', -- dictionary source
      'f3fora/cmp-spell'  -- spell source
    },
    config = function()
      require('plugins.configs.completion')
    end,
  },
  {
    'l3mon4d3/luasnip',
    -- follow latest release.
    version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local ls = require('luasnip')
      ls.log.set_loglevel('debug')
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = './luasnip_snippets/vscode' })
    end
  },
  {
    'smjonas/snippet-converter.nvim',
    config = function()
      local pk = vim.fn.stdpath('data') .. '/site/pack/packer/start'
      local template = {
        sources = {
          ultisnips = {
            pk .. '/vim-snippets/UltiSnips',
            vim.fn.stdpath('config') .. '/UltiSnips',
          },
          snipmate = {
            'vim-snippets/snippets',
          },
        },
        output = {
          vscode_luasnip = {
            vim.fn.stdpath('config') .. '/luasnip_snippets',
          },
        },
      }

      require("snippet_converter").setup {
        templates = { template },
        -- To change the default settings (see configuration section in the documentation)
        -- settings = {},
      }
    end
  }
}
