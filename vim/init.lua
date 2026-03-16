-- plugins
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({ path = { package = path_package } })

local add = MiniDeps.add

add({
  source = "https://github.com/nvim-treesitter/nvim-treesitter",
  checkout = "master",
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

add({
  source = "https://github.com/mason-org/mason-lspconfig.nvim",
  depends = {
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim"
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "cpp", "c", "python", "rust" },
  highlight = { enable = true },
})

require("mason").setup()
require("mason-lspconfig").setup()

require("mini.pick").setup()
require("mini.files").setup()
require("mini.surround").setup()
require("mini.bracketed").setup()
require('mini.trailspace').setup()

-- leader
vim.g.mapleader = ' '

-- misc
vim.opt.termguicolors = false
vim.opt.signcolumn = "no"

-- indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- fold
vim.opt.foldenable = true
vim.opt.foldlevel = 100
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- whitespace
vim.opt.wrap = false
vim.opt.listchars = "trail:¶,tab:→ ,lead:·,space:␣"
vim.keymap.set("i", "<S-TAB>", [[<C-v><TAB>]])
vim.keymap.set("n", "<leader>wd", MiniTrailspace.trim)
vim.keymap.set("n", "<leader>wl", MiniTrailspace.trim_last_lines)

local function toggle_colorcolumn()
  if vim.opt.colorcolumn:get()[1] == nil then
    vim.opt.colorcolumn = "80"
  else
    vim.opt.colorcolumn = ""
  end
end

-- toggles
vim.keymap.set("n", "<leader>tw", [[:set invlist<CR>]])
vim.keymap.set("n", "<leader>tl", [[:set invnumber<CR>]])
vim.keymap.set("n", "<leader>tr", [[:set invrelativenumber<CR>]])
vim.keymap.set("n", "<leader>tc", [[:set invcursorline<CR>]])
vim.keymap.set("n", "<leader>tk", toggle_colorcolumn)
vim.keymap.set("n", "<leader>th", [[:TSToggle highlight<CR>]])

-- editing
vim.keymap.set("v", "<C-h>", [[<gv]])
vim.keymap.set("v", "<C-j>", [[:move '>+1<CR>gv]])
vim.keymap.set("v", "<C-k>", [[:move '<-2<CR>gv]])
vim.keymap.set("v", "<C-l>", [[>gv]])
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

-- files
vim.keymap.set("n", "<leader>fp", [[:Pick files<CR>]])
vim.keymap.set("n", "<leader>fe", [[:Sexplore<CR>]])
vim.keymap.set("n", "<leader>ff", MiniFiles.open)

-- buffers
vim.keymap.set("n", "<leader>b", [[:buffers<CR>:buffer ]])
vim.keymap.set("n", "<leader>d", [[:bdelete<CR>]])
vim.keymap.set("n", "<leader>n", [[:bnext<CR>]])
vim.keymap.set("n", "<leader>p", [[:bprev<CR>]])

-- quickfix list
vim.keymap.set("n", "<leader>co", [[:copen<CR>]])
vim.keymap.set("n", "<leader>cc", [[:cc<CR>]])
vim.keymap.set("n", "<leader>cn", [[:cnext<CR>]])
vim.keymap.set("n", "<leader>cp", [[:cprev<CR>]])

-- location list
vim.keymap.set("n", "<leader>vo", [[:lopen<CR>]])
vim.keymap.set("n", "<leader>vv", [[:ll<CR>]])
vim.keymap.set("n", "<leader>vn", [[:lnext<CR>]])
vim.keymap.set("n", "<leader>vp", [[:lprev<CR>]])

-- netrw
vim.g.netrw_banner = false
vim.g.netrw_sort_options = "i"
