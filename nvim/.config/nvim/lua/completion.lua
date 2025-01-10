local get_packer_path = require('utils').get_packer_path
local ultisnips = require('utils').ultisnips
local get_local_cfgs = require('utils').get_local_cfgs
local ok, cmp = pcall(require, 'cmp')

if ok then
  vim.g.UltiSnipsExpandTrigger = nil
  vim.g.UltiSnipsRemoveSelectModeMappings = 0
  vim.g.UltiSnipsSnippetsDir = os.getenv('HOME') .. '/.config/nvim/UltiSnips/'
  vim.g.UltiSnipsEditSplit = 'vertical'
  vim.g.UltiSnipsSnippetDirectories = { get_packer_path().start .. '/vim-snippets/UltiSnips',
    os.getenv('HOME') .. '/.config/nvim/UltiSnips' }
  local default_mapping = {
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Replace })
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Replace })
      else
        fallback()
      end
    end,
  }

  cmp.setup {
    completion = {
      completeopt = 'menu,menuone,noinsert'
    },
    preselect = cmp.PreselectMode.None,
    enabled = function()
      return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt'
      or require('cmp_dap').is_dap_buffer()
    end,
    snippet = {
      expand = function(args)
        vim.fn['UltiSnips#Anon'](args.body)
      end,
    },
    mapping = {
      ['<C-n>'] = cmp.mapping(function()
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      end, { 'i', 's', }),
      ['<C-p>'] = cmp.mapping(function()
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      end, { 'i', 's', }),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-k>'] = cmp.mapping.scroll_docs(4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-j>'] = cmp.mapping.scroll_docs(-4),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false
      }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.get_selected_entry() == nil and ultisnips.can_expand_snippet() then
          ultisnips.expand_snippet()
        elseif ultisnips.can_jump_forward() then
          ultisnips.jump_forward()
        elseif cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end, { 'i', 's', }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif ultisnips.jump_backwards() then
          ultisnips.jump_backwards()
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    formatting = {
      format = require'lspkind'.cmp_format({
        mode = 'symbol', -- show only symbol annotations
        preset = 'codicons',
        maxwidth = {
          -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- menu = function() return math.floor(0.45 * vim.o.columns) end,
          menu = 50, -- leading text (labelDetails)
          abbr = 50, -- actual suggestion item
        },
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
          buffer = '[BUF]',
          spell = '[SPELL]',
          git = '',
          dictionary = '[DICT]',
          --rg = '[RG]'
        })[entry.source.name]

        return vim_item
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      { name = 'nvim_lsp' },
      { name = 'git' },
      { name = 'path' },
      { name = 'dictionary', keyword_length = 2 },
    },
  }

  local ok_git, cmp_git = pcall(require, 'cmp_git')
  if ok_git then
    local setup = { filetypes = { 'gitcommit', 'octo', 'NeogitCommitMessage', 'vimwiki' } }
    local cfg = get_local_cfgs(setup, 'cmp_git')
    cmp_git.setup(cfg)
  end


  -- use dictionary and snips in document files
  for _, doc_ft in pairs({ 'markdown', 'vimwiki' }) do
    cmp.setup.filetype(doc_ft, {
      sources = {
        { name = 'spell' },
        { name = 'dictionary', keyword_length = 4 },
        { name = 'ultisnips' }
      }
    })
  end

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    completion = { autocomplete = false },
    mapping = default_mapping,
    sources = {
      { name = 'buffer', option = { keyword_pattern = [=[[^[:blank:]].*]=] } }
    }
  })

  cmp.setup.filetype({'dap-repl', 'dapui_watches', 'dapui_hover'}, {
    sources = {
      { name = 'dap' },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    completion = { autocomplete = false },
    mapping = default_mapping,
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
  local ok_dict, cmp_dictionary = pcall(require, 'cmp_dictionary')
  if ok_dict then
    cmp_dictionary.setup({
      dic = {
        ["*"] = { "/usr/share/dict/words" }
      },
      -- The following are default values, so you don't need to write them if you don't want to change them
      exact_length = 2,
      first_case_insensitive = false,
      async = true,
      debug = false,
    })
  end
end
