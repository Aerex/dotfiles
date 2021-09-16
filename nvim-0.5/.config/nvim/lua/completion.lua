local send_keys = require('utils').send_keys
local check_back_space = require('utils').check_back_space
local ultisnips = require('utils').ultisnips
local ok, cmp = pcall(require,'cmp')

if ok then
  -- UltiSnip was auto-removing tab mappings for select mode,
  -- that leads to we cannot jump through snippet stops so we need to disable here
  -- Credits to https://github.com/quangnguyen30192/cmp-nvim-ultisnips/issues/5
  vim.g.UltiSnipsRemoveSelectModeMappings = 0

  local ok_cmp_look, _ = pcall(require, 'cmp_look')
  if ok_cmp_look then
    cmp.register_source('look', require('cmp_look').new())
  end

  cmp.setup {
    completion = {
      completeopt = 'menu,menuone,noinsert'
    },
    snippet = {
      expand = function(args)
        vim.fn['UltiSnips#Anon'](args.body)
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
        elseif vim.fn.pumvisible() == 1 then
          send_keys('<C-n>', 'n')
        elseif check_back_space() then
          send_keys('<tab>', 'n')
        else
          fallback()
        end
      end, {'i','s',}),
      ['<C-Space>'] = cmp.mapping(function(fallback)
        if ultisnips.can_expand_snippet() then
          send_keys('<C-R>=UltiSnips#ExpandSnippet()<CR>', 'n')
        elseif vim.fn.pumvisible() == 1 then
          send_keys('<C-n>', 'n')
        elseif check_back_space() then
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
      { name = 'ultisnips' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'nvim_lua' },
      { name = 'look' }
    },
  }
end
