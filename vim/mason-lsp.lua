local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(
  function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
    client.server_capabilities.semanticTokensProvider = nil
  end
)

local lspconfig = require('lspconfig')

-- C++
lspconfig.clangd.setup{}
lspconfig.neocmake.setup{}

-- QML
lspconfig.qmlls.setup{}

-- Python
lspconfig.pylsp.setup{}

-- HTML
lspconfig.emmet_ls.setup{}
lspconfig.html.setup{}
lspconfig.css_variables.setup{}
lspconfig.eslint.setup{}
lspconfig.jsonls.setup{}
lspconfig.htmx.setup{}

vim.diagnostic.config {
  virtual_text = false,
  signs = false,
  underline = false,
}
