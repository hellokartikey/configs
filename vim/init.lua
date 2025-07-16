-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "mason-org/mason-lspconfig.nvim", opts = {}, dependencies = {
      { "mason-org/mason.nvim", opts = {}, },
      "neovim/nvim-lspconfig",
      },
    },
    { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
  },
})

require('nvim-treesitter.configs').setup({ highlight = { enable = true }})

-- Functions
local function reset_bg()
  vim.cmd.highlight({"Normal", "guibg=none", "ctermbg=none"})
  vim.cmd.highlight({"NormalNC", "guibg=none", "ctermbg=none"})
  vim.cmd.highlight({"EndOfBuffer", "guibg=none", "ctermbg=none"})

  vim.cmd.highlight({"StatusLine", "ctermfg=7", "ctermbg=0", "cterm=reverse"})
  vim.cmd.highlight({"StatusLineNC", "ctermfg=8", "ctermbg=0", "cterm=reverse"})
end

local function o_cycle(opt, on, off)
  return function()
    if vim.api.nvim_get_option_value(opt, {}) == on then
      vim.o[opt] = off
    else
      vim.o[opt] = on
    end
  end
end

local function o_toggle(opt)
  return o_cycle(opt, true, false)
end

local function toggle_diagnostic()
  vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end

local function scratch()
  vim.cmd.enew()
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
end

local function exec_string(cmd)
  if cmd == nil or cmd == "" then return end
  scratch()
  vim.fn.setbufline(vim.fn.bufname(), "$", vim.fn.systemlist(cmd))
end

local function exec(opts)
  exec_string(table.concat(opts.fargs, " "))
end

local function fd_string(inp)
  if inp == nil then inp = "" end
  exec_string("fd --type file " .. inp)

  local function open_range(opts)
    lines = vim.fn.getline(opts.line1, opts.line2)
    for _, line in pairs(lines) do
      vim.cmd.edit(line)
    end
  end

  vim.api.nvim_buf_create_user_command(0, "Line", open_range, { range = true })

  vim.keymap.set("n", "O", [[ggVG:Line<CR>]], { buffer = true })
  vim.keymap.set({"n", "v"}, "o", [[:Line<CR>]], { buffer = true })

  if vim.fn.line("$") == 1 then
    vim.cmd.Open()
    return
  end
end

local function fd(opts)
  fd_string(opts.fargs[1])
end

local function rg(opts)
  local pattern = table.concat(opts.fargs, " ")
  if pattern == "" then return end

  exec_string("rg --vimgrep '" .. pattern .. "'")
  vim.fn.setreg("/", pattern)
  vim.o.hlsearch = true
  vim.cmd.lbuffer()
end

-- Options
vim.o.termguicolors = false

vim.o.wrap = false
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true

vim.o.scrolloff = 10
vim.o.sidescrolloff = 20

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.listchars = "tab:> ,eol:$,space:-"
vim.o.signcolumn = "no"

vim.o.foldenable = true
vim.o.foldlevel = 100
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.pumheight = 5
vim.o.pumwidth = 20

vim.g.netrw_banner = false
vim.g.netrw_sort_options = "i"

vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("ColorScheme", { callback = reset_bg })
vim.cmd.colorscheme("vim")
vim.cmd.match("Error", [[/\s\+$/]])

-- Commands
vim.api.nvim_create_user_command("Rg", rg, { nargs = '+' })
vim.api.nvim_create_user_command("Fd", fd, { nargs = '?' })
vim.api.nvim_create_user_command("Exec", exec, { nargs = '+' })
vim.api.nvim_create_user_command("Scratch", scratch, { nargs = 0 })

-- Remaps
vim.g.mapleader = " "

vim.keymap.set("v", "<", [[<gv]])
vim.keymap.set("v", ">", [[>gv]])
vim.keymap.set("v", "-", [[:m '<-2<CR>gv=gv]])
vim.keymap.set("v", "=", [[:m '>+1<CR>gv=gv]])
vim.keymap.set("i", "<S-TAB>", [[<C-v><TAB>]])
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

vim.keymap.set("n", "<leader>th", [[:TSToggle highlight<CR>]])
vim.keymap.set("n", "<leader>tw", o_toggle("list"))
vim.keymap.set("n", "<leader>tr", o_toggle("relativenumber"))
vim.keymap.set("n", "<leader>tl", o_toggle("number"))
vim.keymap.set("n", "<leader>tc", o_toggle("cursorline"))
vim.keymap.set("n", "<leader>tk", o_cycle("colorcolumn", "", "80"))
vim.keymap.set("n", "<leader>te", toggle_diagnostic)

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

vim.keymap.set("n", "<leader>ws", [[<C-w>s:Scratch<CR>]])
vim.keymap.set("n", "<leader>wv", [[<C-w>v:Scratch<CR>]])

vim.keymap.set("n", "<leader>wh", [[<C-w>h]])
vim.keymap.set("n", "<leader>wj", [[<C-w>j]])
vim.keymap.set("n", "<leader>wk", [[<C-w>k]])
vim.keymap.set("n", "<leader>wl", [[<C-w>l]])

vim.keymap.set("n", "<leader>wH", [[<C-w>H]])
vim.keymap.set("n", "<leader>wJ", [[<C-w>J]])
vim.keymap.set("n", "<leader>wK", [[<C-w>K]])
vim.keymap.set("n", "<leader>wL", [[<C-w>L]])

vim.keymap.set("n", "<leader>w-", [[<C-w>-]])
vim.keymap.set("n", "<leader>w=", [[<C-w>+]])
vim.keymap.set("n", "<leader>w,", [[<C-w><]])
vim.keymap.set("n", "<leader>w.", [[<C-w>>]])
vim.keymap.set("n", "<leader>w_", [[<C-w>_]])
vim.keymap.set("n", "<leader>w|", [[<C-w>|]])
vim.keymap.set("n", "<leader>w+", [[<C-w>=]])

vim.keymap.set("n", "<leader>q", [[:quit<CR>]])
vim.keymap.set("n", "<leader>s", [[:update<CR>]])
vim.keymap.set("n", "<leader>o", [[:edit ]])
vim.keymap.set("n", "<leader>b", [[:buffers<CR>:buffer ]])
vim.keymap.set("n", "<leader>d", [[:bdelete<CR>]])
vim.keymap.set("n", "<leader>n", [[:bnext<CR>]])
vim.keymap.set("n", "<leader>p", [[:bprev<CR>]])

vim.keymap.set("n", "<leader>co", [[:copen<CR>]])
vim.keymap.set("n", "<leader>cc", [[:cc<CR>]])
vim.keymap.set("n", "<leader>cn", [[:cnext<CR>]])
vim.keymap.set("n", "<leader>cp", [[:cprev<CR>]])

vim.keymap.set("n", "<leader>vo", [[:lopen<CR>]])
vim.keymap.set("n", "<leader>vv", [[:ll<CR>]])
vim.keymap.set("n", "<leader>vn", [[:lnext<CR>]])
vim.keymap.set("n", "<leader>vp", [[:lprev<CR>]])

vim.keymap.set("n", "<leader>ft", [[:Explore<CR>]])
vim.keymap.set("n", "<leader>fe", [[:Exec ]])
vim.keymap.set("n", "<leader>fs", [[:Scratch<CR>]])
vim.keymap.set("n", "<leader>fd", [[:Fd ]])
vim.keymap.set("n", "<leader>fr", [[:Rg ]])
