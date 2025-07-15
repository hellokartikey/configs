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

require("nvim-treesitter.configs").setup({ highlight = { enable = true, }, })

-- Functions
local function reset_bg()
  vim.cmd.highlight({ "Normal", "guibg=none", "ctermbg=none" })
  vim.cmd.highlight({ "NonText", "guibg=none", "ctermbg=none" })
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

  vim.api.nvim_buf_create_user_command(0, "Open", open_range, { range = true })

  vim.keymap.set("n", "O", [[ggVG:Open<cr>]], { buffer = true })
  vim.keymap.set({"n", "v"}, "o", [[:Open<cr>]], { buffer = true })

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
vim.o.scrolloff = 5
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.listchars = "tab:> ,eol:$,space:-"
vim.o.signcolumn = "no"
vim.o.foldenable = true
vim.o.foldlevel = 100
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("i", "<s-tab>", [[<c-v><tab>]])

vim.keymap.set("n", "<leader>th", [[:TSToggle highlight<cr>]])
vim.keymap.set("n", "<leader>tw", o_toggle("list"))
vim.keymap.set("n", "<leader>tr", o_toggle("relativenumber"))
vim.keymap.set("n", "<leader>tl", o_toggle("number"))
vim.keymap.set("n", "<leader>tc", o_toggle("cursorline"))
vim.keymap.set("n", "<leader>tk", o_cycle("colorcolumn", "", "80"))
vim.keymap.set("n", "<leader>te", toggle_diagnostic)

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

vim.keymap.set("n", "<leader>h", [[:wincmd h<cr>]])
vim.keymap.set("n", "<leader>j", [[:wincmd j<cr>]])
vim.keymap.set("n", "<leader>k", [[:wincmd k<cr>]])
vim.keymap.set("n", "<leader>l", [[:wincmd l<cr>]])

vim.keymap.set("n", "<leader>H", [[<c-W>H]])
vim.keymap.set("n", "<leader>J", [[<c-W>J]])
vim.keymap.set("n", "<leader>K", [[<c-W>K]])
vim.keymap.set("n", "<leader>L", [[<c-W>L]])

vim.keymap.set("n", "<leader>-", [[:resize -1<cr>]])
vim.keymap.set("n", "<leader>=", [[:resize +1<cr>]])

vim.keymap.set("n", "<leader>_", [[:resize<cr>]])
vim.keymap.set("n", "<leader>|", [[:vertical resize<cr>]])

vim.keymap.set("n", "<leader>,", [[:vertical resize -1<cr>]])
vim.keymap.set("n", "<leader>.", [[:vertical resize +1<cr>]])

vim.keymap.set("n", "<leader>s", [[:update<cr>]])
vim.keymap.set("n", "<leader>o", [[:edit<space>]])
vim.keymap.set("n", "<leader>q", [[:quit<cr>]])

vim.keymap.set("n", "<leader>b", [[:buffers<cr>:buffer<space>]])
vim.keymap.set("n", "<leader>w", [[:bdelete<cr>]])
vim.keymap.set("n", "<leader>n", [[:bnext<cr>]])
vim.keymap.set("n", "<leader>p", [[:bprev<cr>]])

vim.keymap.set("n", "<leader>co", [[:copen<cr>]])
vim.keymap.set("n", "<leader>cc", [[:cc<cr>]])
vim.keymap.set("n", "<leader>cb", [[:cbuffer<cr>]])
vim.keymap.set("n", "<leader>cw", [[:cclose<cr>]])
vim.keymap.set("n", "<leader>cn", [[:cnext<cr>]])
vim.keymap.set("n", "<leader>cp", [[:cprev<cr>]])

vim.keymap.set("n", "<leader>vo", [[:lopen<cr>]])
vim.keymap.set("n", "<leader>vv", [[:ll<cr>]])
vim.keymap.set("n", "<leader>vb", [[:lbuffer<cr>]])
vim.keymap.set("n", "<leader>vw", [[:lclose<cr>]])
vim.keymap.set("n", "<leader>vn", [[:lnext<cr>]])
vim.keymap.set("n", "<leader>vp", [[:lprev<cr>]])

vim.keymap.set("n", "<leader>ft", [[:Explore]])
vim.keymap.set("n", "<leader>fe", [[:Exec<space>]])
vim.keymap.set("n", "<leader>fs", [[:Scratch<cr>]])
vim.keymap.set("n", "<leader>fd", [[:Fd<space>]])
vim.keymap.set("n", "<leader>fr", [[:Rg<space>]])
