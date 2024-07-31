local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(
  function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
  end
)

local lspconfig = require('lspconfig')

lspconfig.clangd.setup({})

vim.cmd("set pumheight=5")

vim.diagnostic.config {
  virtual_text = false,
  signs = false,
  underline = false,
}
