local send_keys = require('utils').send_keys
local get_packer_path = require('utils').get_packer_path
local ultisnips = require('utils').ultisnips
local ok, cmp = pcall(require,'cmp')

if ok then
  vim.g.UltiSnipsExpandTrigger = nil
  vim.g.UltiSnipsRemoveSelectModeMappings = 0
  vim.g.UltiSnipsSnippetsDir = os.getenv('HOME') ..'/.config/nvim/UltiSnips/'
  vim.g.UltiSnipsEditSplit = 'vertical'
  vim.g.UltiSnipsSnippetDirectories = {  get_packer_path().start ..'/vim-snippets/UltiSnips', os.getenv('HOME') .. '/.config/nvim/UltiSnips' }
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
      ['<C-b>'] = cmp.mapping.scroll_docs(4),
      ['<C-f>'] = cmp.mapping.scroll_docs(-4),
      ['<C-u>'] = cmp.mapping.scroll_docs(4),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
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
      end, {'i','s',}),
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
      format = function(entry, vim_item)
        -- load lspkind icons
        vim_item.kind = string.format(
          '%s %s',
          require('nvim-lsp.utils').symbol_map[vim_item.kind],
          vim_item.kind
        )

        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
          buffer = '[BUF]',
          spell = '[SPELL]',
          dictionary = '[DICT]',
          --rg = '[RG]'
        })[entry.source.name]

        return vim_item
      end,
    },
    sources = {
      { name = 'ultisnips'},
      { name = 'nvim_lsp'},
      --{ name = 'rg'},
      { name = 'path'},
      { name = 'dictionary', keyword_length = 2},
    },
  }

  -- use dictionary and snips in document files
  for _, doc_ft in pairs({'markdown', 'vimwiki'}) do
    cmp.setup.filetype(doc_ft, {
      sources = {
        { name = 'spell'},
        { name = 'dictionary',  keyword_length = 4},
        { name = 'ultisnips'}
      }
    })
  end

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    completion = { autocomplete = false},
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
      exact = 2,
      first_case_insensitive = false,
      async = true,
      capacity = 5,
      debug = false,
    })
  end
end
