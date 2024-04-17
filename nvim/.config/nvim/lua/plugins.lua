local autocmd = require('utils').autocmd
local execute = vim.api.nvim_command
local fn = vim.fn

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.lazy.rtp:prepend(lazypath)

autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = 'plugins.lua',
  callback = function(args)
    vim.keymap.set('n', '\\ps', function() require 'packer'.sync() end, { silent = true, buffer = args.buf })
    vim.keymap.set('n', '\\pi', function() require 'packer'.install() end, { silent = true, buffer = args.buf })
    vim.keymap.set('n', '\\pc', function() require 'packer'.compile() end, { silent = true, buffer = args.buf })
    vim.keymap.set('n', '\\pS', '<cmd>PackerStatus<cr>', { silent = true, buffer = args.buf })
  end
})


return require('lazy').setup({
  function(use)

    -- textobject
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-repeat' }


    -- yank/undo
    use {
      { lazy = true,            'mbbill/undotree', cmd = 'UndotreeToggle', config = [[vim.g.undotree_SetFocusWhenToggle = 1]] },
      { 'bfredl/nvim-miniyank', as = 'miniyank' }
    }
    use { 'gbprod/yanky.nvim',
      config = function()
        require('yanky').setup({
          ring = {
            storage = 'sqlite',
            history_length = 100,
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


    -- debugger

    -- test

    -- statusline
    use { 'glepnir/galaxyline.nvim', dependencies = { 'kyazdani42/nvim-web-devicons' },
      config = function() require('statusline') end
    }
    use { 'tpope/vim-dispatch', cmd = { 'Dispatch' } }

    -- completions / snippets
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
      config = function() require 'toggleterm'.setup { open_mapping = [[<C-t>]], shading_factor = 1, direction = 'float' } end
    }
    use { 'AndrewRadev/bufferize.vim', cmd = { 'Bufferize' } }
    use { 'kevinhwang91/nvim-bqf', dependencies = { 'junegunn/fzf', build = function() vim.fn['fzf#install']() end },
      ft = 'qf', config = function() require 'qf' end }
    use { 'NTBBloodbath/rest.nvim', ft = { 'http' }, dependencies = { 'nvim-lua/plenary.nvim', config = function()
      require 'rest'
    end } }
    use { 'vimwiki/vimwiki', ft = { 'vimwiki', 'markdown' },
      setup = function()
        vim.g.vimwiki_key_mappings = { headers = 0, html = 0, global = 0, links = 0 }
      end }
    use { 'dhruvasagar/vim-table-mode', cmd = { 'TableModeToggle', 'TableModeEnable', 'TableModeDisable', 'Tabelize', 'TableModeRealign',
      config = function() vim.table_mode_auto_align = 1 end } }
    use {
      'voldikss/vim-translator', cmd = { 'Translate', 'TranslateR', 'TranslateW', 'TranslateL' }, ft = { "trans" }
    }
    use { 'rcarriga/nvim-notify', config = function()
      require 'notify'.setup({
        background_colour = "#646A76", timeout = 1500, render = 'minimal'
      })
    end }
    use { 'ledger/vim-ledger', ft = { 'ledger' }, config = function() require 'ledger' end }
    use { 'iamcco/markdown-preview.nvim', build = 'cd app && npm install',
      cmd = { 'MarkdownPreview', 'MarkdownPreviewStop' }, ft = { 'markdown' },
      config = function() vim.p.mkdp_filetypes = { 'markdown', 'vimwiki' } end
    }
  end
})
