local send_keys = require('utils').send_keys
local get_packer_path = require('utils').get_packer_path
local has_any_words_before = require('utils').has_any_words_before
local ultisnips = require('utils').ultisnips
local ok, cmp = pcall(require,'cmp')

if ok then
  vim.g.UltiSnipsExpandTrigger = 'None'
  vim.g.UltiSnipsRemoveSelectModeMappings = 0
  vim.g.UltiSnipsSnippetsDir = os.getenv('HOME') ..'/.config/nvim/UltiSnips/'
  vim.g.UltiSnipsEditSplit = 'vertical'
  vim.g.UltiSnipsSnippetDirectories = {  get_packer_path().start ..'/vim-snippets/UltiSnips', os.getenv('HOME') .. '/.config/nvim/UltiSnips' }

  cmp.setup {
    completion = {
      completeopt = 'menu,menuone,noinsert'
    },
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-b'] = cmp.mapping.scroll_docs(4),
      ['<C-f'] = cmp.mapping.scroll_docs(-4),
      ['<C-u'] = cmp.mapping.scroll_docs(4),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<CR>'] = cmp.mapping.confirm {
        select = false -- Only confirm explicitly selected items
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.get_selected_entry() == nil and ultisnips.can_expand_snippet() then
          ultisnips.expand_snippet()
        elseif ultisnips.can_jump_forward() then
          ultisnips.jump_forward()
        elseif cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, {'i','s',}),
      ['<C-Space>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if ultisnips.can_expand_snippet() then
            print('expanding snippet on c-space')
            return ultisnips.expand_snippet()
          end
          cmp.select_next_item()
        elseif has_any_words_before() then
          send_keys('<Space>', 'n')
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if ultisnips.can_jump_forward() then
          ultisnips.jump_backwards()
        elseif cmp.visible() then
          cmp.select_prev_item()
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
          rg = '[RG]'
        })[entry.source.name]

        return vim_item
      end,
    },
    sources = {
      { name = 'nvim_lsp', priority = 5 },
      { name = 'ultisnips', priority = 3 },
      { name = 'rg', priority = 2 },
      { name = 'dictionary', keyword_length = 2},
    },
  }

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
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
