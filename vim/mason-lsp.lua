local lsp_zero = require('lsp-zero')

lsp_zero.on_attach( function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr })
end )

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
  },
})

require('trouble').setup({
  icons = false,
  fold_open = '▾',
  fold_closed = '▸',
  indent_lines = false,
  signs = {
    error = "E",
    warning = "W",
    hint = "H",
    information = "I"
  },
  use_diagnostic_signs = false
})

vim.cmd("set scl=no")

vim.diagnostic.config {
  virtual_text = false,
  signs = false,
  underline = false,
}

