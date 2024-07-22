local utils = require('utils')
local autocmd = utils.autocmd
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end


vim.api.nvim_create_user_command("PackerBackup", function()
  utils.backup_plugins()
end, {
  complete = 'file',
  nargs = '*'
})
vim.keymap.set('n', ',pb', ":PackerBackup")

-- Auto compile when there are changes in plugins.lua
autocmd('BufWritePre', {
  pattern = '~/.config/nvim/lua/plugins.lua',
  command = 'PackerCompile'
})

autocmd({ 'BufEnter', 'BufRead' }, {
  pattern = 'plugins.lua',
  callback = function(args)
    vim.keymap.set('n', ',ps', function()
      utils.backup_plugins()
      require 'packer'.sync()
    end, { silent = true, buffer = args.buf })
    vim.keymap.set('n', '\\pu', function() require 'packer'.update() end, { silent = true, buffer = args.buf })
    vim.keymap.set('n', '\\pi', function() require 'packer'.install() end, { silent = true, buffer = args.buf })
    vim.keymap.set('n', '\\pb', function()
    end, { silent = true, buffer = args.buf })
    vim.keymap.set('n', '\\pc', function()
      require 'packer'.compile()
      vim.notify('Packer Compiled', vim.log.levels.WARN)
      local filename = os.date("%Y%m%dT%H%M")
      require 'packer'.snapshot(filename)
      vim.notify('Packer Snapshot created: ' .. filename, vim.log.levels.INFO)
    end, { silent = true, buffer = args.buf })
    vim.keymap.set('n', '\\pS', '<cmd>PackerStatus<cr>', { silent = true, buffer = args.buf })
  end
})

-- Do not remove unusued plugins
require('packer').init({ display = { auto_clean = true } })
-- Only required if you have packer in your `opt` pack
local ok, _ = pcall(vim.cmd, [[packadd packer.nvim]])

if ok then
  return require('packer').startup({
    function(use)
      -- Packer can manage itself as an optional plugin
      use { 'wbthomason/packer.nvim' }
      use { 'lewis6991/impatient.nvim' }
      use { 'folke/which-key.nvim', config = function() require 'which_key'.setup() end }
      use({ 'milkias17/reloader.nvim', requires = { { 'nvim-lua/plenary.nvim' } } })

      -- lsp
      use { 'neovim/nvim-lspconfig', requires = { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
        config = function() require('nvim-lsp') end }
      use { 'mfussenegger/nvim-jdtls' }
      use { 'jose-elias-alvarez/null-ls.nvim' }
      use { 'onsails/lspkind-nvim' }
      use { 'ray-x/lsp_signature.nvim' }
      use { 'folke/neodev.nvim' }
      use { 'ray-x/navigator.lua', requires = { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' } }
      use { 'rmagatti/goto-preview' }
      use { 'amrbashir/nvim-docs-view', cmd = { "DocsViewToggle" }, config = function()
        require("docs-view").setup {
          position = "right",
          width = 60,
        }
      end }
      use({
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = function()
          require('fidget').setup({
            window = {
              relative = 'editor',
              blend = 0,
            },
            sources = {
              ['null-ls'] = {
                ignore = true
              },
            },
          })
        end,
      })
      use { "aznhe21/actions-preview.nvim",
        config = function()
          vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
        end, }

      -- treesitter
      use { 'nvim-treesitter/nvim-treesitter', requires = {
        'nvim-treesitter/nvim-treesitter-refactor', 'nvim-treesitter/nvim-treesitter-textobjects',
        { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' }
      }, config = function() require('treesitter') end, run = ':TSUpdate'
      }

      -- textobject
      use { 'tpope/vim-repeat' }
      use { 'kylechui/nvim-surround', tag = "*", config = function() require 'nvim-surround'.setup({}) end }

      -- fuzzy pickers / file finders
      use { 'vijaymarupudi/nvim-fzf' }
      use { 'vijaymarupudi/nvim-fzf-commands' }
      use { "ibhagwan/fzf-lua", config = function()
        require 'fzf-lua'.setup({
          'telescope',
          actions = {
            files = {
              ["ctrl-s"]  = require 'fzf-lua.actions'.file_split,
              ["ctrl-x"]  = require 'fzf-lua.actions'.file_split,
              ["ctrl-v"]  = require 'fzf-lua.actions'.file_vsplit,
              ["default"] = require 'fzf-lua.actions'.file_edit_or_qf
            },
            keymap = {
              fzf = {
                ["alt-j"] = "preview-page-down",
                ["alt-k"] = "preview-page-up"
              }
            }
          }
        })
      end, requires = {
        "nvim-tree/nvim-web-devicons" } }
      use { lazy = true, 'leisiji/fzf_utils' }
      use { 'vifm/vifm.vim' }

      -- git
      use { 'tpope/vim-fugitive', cmd = { 'Gwrite', 'Git', 'Gpush', 'GBrowse', 'Gdiffsplit' },
        requires = { 'tpope/vim-rhubarb' } }
      use { 'ruifm/gitlinker.nvim', config = function() require('nvim-git').setup_gitlinker() end }
      use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, event = { 'BufRead' },
        config = function() require('nvim-git').setup_signs() end }
      use { 'rhysd/git-messenger.vim', cmd = { 'GitMessenger' } }

      use { 'nvim-telescope/telescope.nvim', config = function() require 'nvim-telescope'.setup() end, requires = {
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        { 'nvim-telescope/telescope-fzf-writer.nvim' }
      } }
      use { opt = true, 'Aerex/gh.nvim', requires = { 'ldelossa/litee.nvim' },
        config = function() require 'nvim-git'.setup_gh() end }
      use { 'NeogitOrg/neogit', cmd = { 'Neogit' }, config = function() require('nvim-git').setup_neogit() end,
        requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim', 'ibhagwan/fzf-lua' } }
      use { opt = true, 'pwntester/octo.nvim', cmd = { 'Octo' },
        requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' },
          {
            'nvim-telescope/telescope.nvim',
            config = function()
              require 'telescope'.setup({
                pickers = {
                  octo = {
                    theme = 'ivy'
                  }
                }
              })
            end,
          } },
        config = function() require('nvim-git').setup_octo() end }

      -- yank/undo
      use { 'gbprod/yanky.nvim',
        requires = 'kkharji/sqlite.lua',
        config = function()
          require('yanky').setup({
            ring = {
              storage = 'sqlite',
              history_length = 200,
            },
            system_clipboard = {
              sync_with_ring = true,
            },
            highlight = {
              on_put = true,
              on_yank = true,
              timer = 500,
            },
            preserve_cursor_position = {
              enabled = true,
            },
          })
        end
      }

      -- diagnostics
      use { 'folke/trouble.nvim', config = function() require 'nvim-trouble'.setup() end }
      use { 'folke/todo-comments.nvim', event = "BufRead", requires = 'nvim-lua/plenary.nvim',
        config = function() require('nvim-trouble').todo.setup() end }

      -- formatting
      use { 'sbdchd/neoformat' }
      use { 'mhartington/formatter.nvim', config = function() require 'format'.setup() end }
      use { 'godlygeek/tabular', cmd = { 'Tabularize' } }
      use { 'lukas-reineke/indent-blankline.nvim',
        config = function()
          require('ibl').setup({
            indent = { char = '|' },
            exclude = { buftypes = { 'terminal' }, filetypes = { 'ledger', 'help' } }
          })
        end
      }
      -- colors
      use {
        { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end },
        'chriskempson/base16-vim',
        'rmehri01/onenord.nvim', config = function() require('colors').setup() end,
        'miyakogi/seiya.vim', -- enable transparent background
        { 'p00f/nvim-ts-rainbow',        requires = { 'nvim-treesitter/nvim-treesitter' } }
      }

      -- debugger
      use {
        'mfussenegger/nvim-dap',
        requires = { 'nvim-neotest/nvim-nio', 'rcarriga/nvim-dap-ui', 'suketa/nvim-dap-ruby', 'mfussenegger/nvim-dap-python',
          'theHamsta/nvim-dap-virtual-text' },
        config = function() require('debugger') end
      }

      use { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } }
      use {
        'microsoft/vscode-js-debug',
        run = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
        config = function()
          require 'dap-vscode-js'.setup({
            adapters = { 'pwa-node' },
            debugger_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/vscode-js-debug'
          })
        end
      }

      -- test
      use {
        'rcarriga/vim-ultest',
        cmd = { 'Ultest', 'UltestNearest' },
        run = ':UpdateRemotePlugins',
        requires = { { 'vim-test/vim-test', cmd = { 'TestFile', 'TestLast', 'TestSuite', 'TestVisit', 'TestNearest' } } },
        config = function() require('test').setup() end
      }

      use {
        'andythigpen/nvim-coverage',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
          require('coverage').setup()
        end,
      }
      use { 'nvim-neotest/neotest', requires = {
        'nvim-neotest/neotest-go',
        'nvim-neotest/neotest-jest',
        'olimorris/neotest-rspec',
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim'
      }, config = function() require('test').setup() end
      }

      -- statusline
      use { 'glepnir/galaxyline.nvim', requires = { 'nvim-tree/nvim-web-devicons' },
        config = function() require('status').galaxy() end
      }
      use { 'nanozuki/tabby.nvim', config = function()
        require('tabby.tabline').use_preset('tab_only', {
          theme = {
            fill = 'TabLineFill',       -- tabline background
            head = 'TabLine',           -- head element highlight
            current_tab = 'TabLineSel', -- current tab label highlight
            tab = 'TabLine',            -- other tab label highlight
            win = 'TabLine',            -- window highlight
            tail = 'TabLine',           -- tail element highlight
          },
          nerdfont = true,              -- whether use nerdfont
          buf_name = {
            mode = "'unique'|'relative'|'tail'|'shorten'",
          },
        })
      end }
      use { 'tpope/vim-dispatch', cmd = { 'Dispatch' } }

      -- completions / snippets
      use({
        -- nvim-cmp
        'hrsh7th/nvim-cmp',
        requires = {
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-nvim-lua',
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-cmdline',
          'dmitmel/cmp-cmdline-history',
          { 'davidsierradz/cmp-conventionalcommits', ft = { 'NeogitCommitMessage' } },
          'uga-rosa/cmp-dictionary',
          { lazy = true,                             'lukas-reineke/cmp-rg' },
          'hrsh7th/cmp-look', -- dictionary source
          'f3fora/cmp-spell', -- spell source
          {
            'SirVer/ultisnips',
            'quangnguyen30192/cmp-nvim-ultisnips',
            'honza/vim-snippets',
          }
        },
        config = function()
          require('completion')
        end,
      })
      -- profiling
      use { 'tweekmonster/startuptime.vim' }
      use { 'sunaku/vim-dasht', config = function()
        vim.g.dasht_filetype_docsets = {
          typescript = { 'Mocha', 'Sinon' },
          javascript = { 'Mocha', 'Sinon' }
        }
      end }

      -- marks
      use { 'kshenoy/vim-signature' }
      -- terminal
      use {
        'akinsho/nvim-toggleterm.lua',
        config = function()
          require 'toggleterm'.setup {
            open_mapping = [[<C-t>]],
            shading_factor = 1,
            auto_scroll = false,
            direction = 'float'
          }
        end
      }
      use { 'AndrewRadev/bufferize.vim', cmd = { 'Bufferize' } }
      use { 'kevinhwang91/nvim-bqf', requires = { 'junegunn/fzf' },
        ft = 'qf', config = function() require 'qf' end }
      use { 'NTBBloodbath/rest.nvim', commit = "8b62563", ft = { 'http' },
        config = function() require 'rest'.setup() end, requires = { 'nvim-lua/plenary.nvim' } }
      use { 'vimwiki/vimwiki', ft = { 'vimwiki', 'markdown' },
        setup = function()
          vim.g.vimwiki_key_mappings = { headers = 0, html = 0, global = 0, links = 0 }
        end }
      use { 'dhruvasagar/vim-table-mode',
        cmd = {
          'TableModeToggle',
          'TableModeEnable',
          'TableModeDisable',
          'Tabelize',
          'TableModeRealign',
          config = function() vim.table_mode_auto_align = 1 end
        } }
      --use {
      --  'voldikss/vim-translator', cmd = { 'Translate', 'TranslateR', 'TranslateW', 'TranslateL' }, ft = { "trans" }
      --}
      use { 'rcarriga/nvim-notify', config = function()
        require 'notify'.setup({
          background_colour = "#646A76", timeout = 1500, render = 'minimal'
        })
      end }
      --use { 'ledger/vim-ledger', ft = { 'ledger' }, config = function() require 'ledger' end }
      use { 'iamcco/markdown-preview.nvim', run = 'cd app && npm install',
        cmd = { 'MarkdownPreview', 'MarkdownPreviewStop' }, ft = { 'markdown' },
        config = function() vim.g.mkdp_filetypes = { 'markdown', 'vimwiki' } end
      }
      use { 'williamboman/mason.nvim', requires = 'williamboman/mason-lspconfig.nvim',
        config = function()
          require 'mason'.setup();
          require 'mason-lspconfig'.setup()
        end }
      use { 'smjonas/snippet-converter.nvim', config = function()
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
      end }
      use { 'xarthurx/taskwarrior.vim', cmd = { 'TW', 'TWUndo', 'TWEditTaskrc', 'TWEditVitrc', 'TWDeleteCompleted',
        'TWAdd', 'TWAnnotate', 'TWComplete', 'TWDelete', 'TWDeleteAnnotation', 'TWModifyInteractive', 'TWReportInfo',
        'TWReportSort',
        'TWSync', 'TWToggleReadonly', 'TWToggleHLField', 'TWHistory', 'TWHistoryClear', 'TWBookmark', 'TWBookmarkClear' }
      }
      use { 'michaelb/sniprun', run = 'bash install.sh', requires = { tag = 'v0.4.1', 'LintaoAmons/scratch.nvim' },
        config = function()
          require('scratch').setup {
            scratch_file_dir = vim.fn.stdpath('cache') .. '/scratch.nvim',        -- Where the scratch files will be saved
            filetypes = { 'json', 'xml', 'go', 'lua', 'js', 'py', 'sh', 'ruby' }, -- filetypes to select from
          }
        end
      }
      use { opt = true, 'felipec/notmuch-vim', setup = function() require 'mail' end }
    end,
    config = {
      display = {
        open_fn = function()
          return require('packer.util').float({ border = 'single' })
        end
      }
    }
  })
end
