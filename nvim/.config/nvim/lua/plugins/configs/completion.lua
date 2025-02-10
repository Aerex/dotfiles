local get_packer_path = require('utils').get_packer_path
local get_local_cfgs = require('utils').get_local_cfgs
local ok, cmp = pcall(require, 'cmp')
local luasnip = require('luasnip')
luasnip.log.set_loglevel('debug')

if ok then
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
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end, { 'i', 's', }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    formatting = {
      format = function(entry, vim_item)
        -- load lspkind icons
        vim_item.kind = string.format(
          '%s %s',
          require('utils').symbol_map[vim_item.kind],
          vim_item.kind
        )

        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
          buffer = '[BUF]',
          spell = '[SPELL]',
          dictionary = '[DICT]',
          git = '',
          --rg = '[RG]'
        })[entry.source.name]

        return vim_item
      end,
    },
    sources = {
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'git' },
      --{ name = 'rg'},
      { name = 'path' },
      { name = 'dictionary', keyword_length = 2 },
    },
  }

  local ok_git, cmp_git = pcall(require, 'cmp_git')
  if ok_git then
    local setup = {}
    local cfg = get_local_cfgs(setup, 'cmp_git')
    cmp_git.setup(cfg)
  end

  -- use dictionary and snips in document files
  for _, doc_ft in pairs({ 'markdown', 'vimwiki' }) do
    cmp.setup.filetype(doc_ft, {
      sources = {
        { name = 'spell' },
        { name = 'dictionary', keyword_length = 4 },
        { name = 'luasnip' }
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
