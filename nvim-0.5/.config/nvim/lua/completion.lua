local send_keys = require('utils').send_keys
local get_packer_path = require('utils').get_packer_path
local has_any_words_before = require('utils').has_any_words_before
local ultisnips = require('utils').ultisnips
local ok, cmp = pcall(require,'cmp')

if ok then
  -- UltiSnip was auto-removing tab mappings for select mode,
  -- that leads to we cannot jump through snippet stops so we need to disable here
  -- Credits to https://github.com/quangnguyen30192/cmp-nvim-ultisnips/issues/5
  vim.g.UltiSnipsExpandTrigger = '<c-S>'
  vim.g.UltiSnipsRemoveSelectModeMappings = 0
  vim.g.UltiSnipsSnippetsDir = os.getenv('HOME') ..'/.config/nvim/UltiSnips/'
  vim.g.UltiSnipsEditSplit = 'vertical'
  vim.g.UltiSnipsSnippetDirectories = { os.getenv('HOME') .. '/.config/nvim/UltiSnips', get_packer_path().start ..'/vim-snippets/UltiSnips' }

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
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if ultisnips.can_expand_snippet() then
          ultisnips.expand_snippet()
        elseif ultisnips.can_jump_forward() then
          ultisnips.jump_forward()
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif has_any_words_before() then
          send_keys('<tab>', '')
        else
          fallback()
        end
      end, {'i','s',}),
      ['<C-Space>'] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          if ultisnips.can_expand_snippet() then
            return ultisnips.expand_snippet()
          end
          send_keys('<C-n>', 'n')
        elseif has_any_words_before() then
          send_keys('<CR>', 'n')
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if ultisnips.can_jump_forward() then
          ultisnips.jump_backwards()
        elseif vim.fn.pumvisible() == 1 then
          send_keys('<C-p>', 'n')
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
        })[entry.source.name]

        return vim_item
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'nvim_lua' },
      { name = 'path' },
      { name = 'ultisnips' },
    },
  }
end
