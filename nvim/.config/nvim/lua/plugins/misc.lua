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
    dir = '~/Documents/repos/.private/wca.nvim/',
    dependencies = {
      'MunifTanjim/nui.nvim'
    },
    config = function()
      require'wca'.setup({})
    end
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim", -- optional
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    'kkoomen/vim-doge'
  },
  {

    'olimorris/codecompanion.nvim',
    config = function()
          require('codecompanion').setup({
            opts = {
              log_level = 'TRACE',
              send_code = false,
            },
            display = {
              action_palette = {
                width = 95,
                height = 10,
                prompt = "Prompt ",                   -- Prompt used for interactive LLM calls
                provider = "telescope",               -- default|telescope|mini_pick
                opts = {
                  show_default_actions = true,        -- Show the default actions in the action palette?
                  show_default_prompt_library = true, -- Show the default prompt library in the action palette?
                },
              },
              strategies = {
                chat = {
                  adapter = 'llama3_1'
                },
                inline = {
                  adapter = 'ollama'
                }
              },
              adapters = {
                openai = function()
                  return require('codecompanion.adapters').extend('openai', {
                    name = 'openaimod',
                    env = {
                      api_key = "cmd:pass openai.com/token"
                    },
                    schema = {
                      model = {
                        default = 'gpt-4o-mini'
                      }
                    }
                  })
                end,
                llama3_1 = function()
                  return require('codecompanion.adapters').extend('ollama', {
                    name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
                    schema = {
                      model = {
                        default = "llama3.1:latest",
                      },
                      num_ctx = {
                        default = 16384,
                      },
                      num_predict = {
                        default = -1,
                      },
                    },
                  })
                end
              }
            }
          })
        end,
        requires = {
          'nvim-lua/plenary.nvim',
          'nvim-treesitter/nvim-treesitter',
        }
  },
  {
    dir = '~/Documents/repos/ibm/wca.nvim',
    opts = {

    }
  }
}
