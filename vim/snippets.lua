local cmp = require('cmp')
local cmp_lsp = require('lsp-zero').cmp_format()
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<TAB>'] = cmp_action.tab_complete(),
    ['<S-TAB>'] = cmp_action.select_prev_or_fallback(),
    ['<CR>'] = cmp.mapping.confirm({select = false})
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }),
  formatting = cmp_format
})

require('luasnip.loaders.from_snipmate').lazy_load()

