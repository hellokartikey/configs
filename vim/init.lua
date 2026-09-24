vim.pack.add {
  "https://github.com/neovim-treesitter/nvim-treesitter",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/junegunn/fzf.vim",
  "https://github.com/mbbill/undotree"
}

-- undotree
local UNDODIR = vim.fn.expand('~/.cache/nvim/undodir')

if vim.fn.isdirectory(UNDODIR) == 0 then
  vim.fn.mkdir(UNDODIR, "p", 0700)
end

vim.opt.undodir = UNDODIR
vim.opt.undofile = true

vim.g.undotree_WindowLayout = 3
--

-- mini.nvim
require("mini.ai").setup()
require("mini.surround").setup()
require("mini.bracketed").setup()
require("mini.move").setup()
require("mini.pairs").setup()
require("mini.completion").setup({ delay = { completion = 2^16 } })
require("mini.trailspace").setup()
--

-- fzf.vim
vim.g.fzf_vim = {
  preview_window = {},
  options = { "--no-footer" }
}

vim.g.fzf_layout = { window = "enew" }
--

-- nvim-treesitter
require('nvim-treesitter').setup()
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("hk_config", { clear = false }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)

    if not lang or not vim.treesitter.language.add(lang) then
      return
    end

    if vim.treesitter.query.get(lang, "highlights") then
      vim.treesitter.start(ev.buf)
    end

    if vim.treesitter.query.get(lang, "indent") then
      vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    end

    if vim.treesitter.query.get(lang, "folds") then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end
})
--

-- lsp-config
vim.lsp.enable('clangd')
vim.lsp.enable('lua-language-server')

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("hk_config", { clear = false }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end
})
--

-- colors
function set_background(ev)
  vim.cmd([[:highlight Normal      ctermbg=none guibg=none]])
  vim.cmd([[:highlight NormalNC    ctermbg=none guibg=none]])
  vim.cmd([[:highlight EndOfBuffer ctermbg=none guibg=none]])
end

vim.cmd.colorscheme("unokai")
set_background()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_background })
--

-- options
vim.opt.termguicolors = false

vim.opt.wrap = false
vim.opt.breakindent = true

vim.opt.scrolloff = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true

local LIST_ALL = { eol = "¶", tab = "→ ", trail = "¿", leadmultispace = "⋅ ", leadtab = "→ " }
local LIST_DEF = { leadmultispace = "⋅ ", tab = "  ",  leadtab = "→ " }
vim.opt.listchars = LIST_DEF
vim.opt.list = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.scl = "no"
vim.opt.completeopt = { "menu", "noselect" }
vim.opt.pumheight = 5
vim.opt.pummaxwidth = 50

local COLUMN_DEF = {}
local COLUMN_ALL = { 80, 120 }
vim.opt.colorcolumn = COLUMN_DEF
vim.opt.cursorline = false

vim.opt.foldlevel = 2^16

vim.g.netrw_banner = 0
vim.g.netrw_sort_option = "i"
--

-- keymaps
function toggle_list()
  if vim.deep_equal(vim.opt.listchars:get(), LIST_DEF) then
    vim.opt.listchars = LIST_ALL
  else
    vim.opt.listchars = LIST_DEF
  end
end

function toggle_column()
  if vim.deep_equal(vim.opt.colorcolumn:get(), COLUMN_DEF) then
    vim.opt.colorcolumn = COLUMN_ALL
  else
    vim.opt.colorcolumn = COLUMN_DEF
  end
end

vim.g.mapleader = " "
vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]])

vim.keymap.set("i", "<C-n>", [[<C-x><C-o>]])
vim.keymap.set("i", "<S-TAB>", [[<C-v><TAB>]])

vim.keymap.set("n", "<leader>d", [[:bdelete<CR>]])
vim.keymap.set("n", "<leader>q", [[:bdelete!<CR>]])
vim.keymap.set("n", "<leader>u", [[:UndotreeToggle<CR>:UndotreeFocus<CR>]])
vim.keymap.set("n", "<leader>x", [[:Explore<CR>]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

vim.keymap.set("n", "<leader>tn", [[:set number!<CR>]])
vim.keymap.set("n", "<leader>tr", [[:set relativenumber!<CR>]])
vim.keymap.set("n", "<leader>tc", [[:set cursorline!<CR>]])
vim.keymap.set("n", "<leader>tk", toggle_column)
vim.keymap.set("n", "<leader>tw", toggle_list)

vim.keymap.set("n", "<leader>wd", MiniTrailspace.trim)
vim.keymap.set("n", "<leader>wl", MiniTrailspace.trim_last_lines)

vim.keymap.set("n", "<leader>f", [[:Files<CR>]])
vim.keymap.set("n", "<leader>b", [[:Buffers<CR>]])
vim.keymap.set("n", "<leader>r", [[:RG<CR>]])
--
