return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
    }
  },
  {
    'rest-nvim/rest.nvim',
    ft = { 'http' },
    branch = 'v3.8.4',
    opts = {
      ensure_installed = { "http" },
      sync_install = false,
      indent = { enable = true },
    },
    config = function()
      require 'plugins.configs.misc'.rest.setup()
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
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
    'voldikss/vim-translator',
    cmd = { 'Translate', 'TranslateR', 'TranslateW', 'TranslateL' },
    ft = { 'trans' }
  },
  {
    'ledger/vim-ledger',
    ft = { 'ledger' },
    config = function()
      require 'plugins.configs.misc'.ledger.setup()
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
  },
  {
    'kkoomen/vim-doge'
  },
  {
    'olimorris/codecompanion.nvim',
    config = function()
      require('codecompanion').setup({
        adapters = {
          http = {
            anthropic = function()
              return require('codecompanion.adapters').extend('anthropic', {
                env = {
                  api_key = 'cmd:pass claude.com/token'
                },
              })
            end,
          }
        },
        interactions = {
          chat = {
            adapter = 'anthropic',
            model = 'claude-sonnet-4-20250514'
          },
          inline = {
            adapter = 'anthropic'
          },
        },
        opts = {
          log_level = 'TRACE',
        },
      })
    end,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    }
  },
  {
    lazy = true,
    'iamironz/android-nvim-plugin',
    config = function()
      require('android').setup()
    end,
  },
  {
    'kawre/leetcode.nvim',
    dependencies = {
        -- include a picker of your choice, see picker section for more details
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
    },
    opts = {
      lang = "python"
        -- configuration goes here
    },
}
}
