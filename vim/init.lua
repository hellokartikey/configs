-- Constants
local COLUMN = "80"

-- Plugins
require("lazy_config")

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

local function scratch()
  vim.cmd.enew()
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
end

local function command(cmd)
  if cmd == nil or cmd == "" then return end
  scratch()
  vim.fn.setbufline(vim.fn.bufname(), "$", vim.fn.systemlist(cmd))
end

local function exec(prefix)
  vim.ui.input({ prompt = "cmd > " }, command)
end

local function fd(auto_open)
  vim.ui.input({ prompt = "fd > " }, function(inp)
      if inp == nil then return end
      command("fd --type file " .. inp)

      local function open_range(from, to)
        return function()
          lines = vim.fn.getline(from, to)
          for _, line in pairs(lines) do
            vim.cmd.edit(line)
          end
        end
      end

      vim.keymap.set("n", "O", open_range(0, "$"), { buffer = true })
      vim.keymap.set("n", "o", open_range(".", "."), { buffer = true })
      -- FIXME - vim.keymap.set("v", "o", open_range(""<", "">"), { buffer = true })

      if vim.fn.line(".") == vim.fn.line("$") then
        print("single line")
        open_range(".", ".")()
        return
      end
    end)
end

-- Remaps
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ft", vim.cmd.Explore)
vim.keymap.set("n", "<leader>fe", exec)
vim.keymap.set("n", "<leader>fs", scratch)
vim.keymap.set("n", "<leader>fd", fd)

vim.keymap.set("n", "<leader>s", vim.cmd.update)
vim.keymap.set("n", "<leader>o", ":edit<space>")
vim.keymap.set("n", "<leader>b", ":buffers<cr>:buffer<space>")
vim.keymap.set("n", "<leader>w", vim.cmd.bdelete)
vim.keymap.set("n", "<leader>n", vim.cmd.bnext)
vim.keymap.set("n", "<leader>p", vim.cmd.bprev)
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("v", "<leader>[", "<gv")
vim.keymap.set("v", "<leader>]", ">gv")

vim.keymap.set("n", "<leader>co", vim.cmd.copen)
vim.keymap.set("n", "<leader>cc", vim.cmd.cc)
vim.keymap.set("n", "<leader>cb", vim.cmd.cbuffer)
vim.keymap.set("n", "<leader>cn", vim.cmd.cnext)
vim.keymap.set("n", "<leader>cp", vim.cmd.cprev)

vim.keymap.set("n", "<leader>lo", vim.cmd.lopen)
vim.keymap.set("n", "<leader>ll", vim.cmd.ll)
vim.keymap.set("n", "<leader>lb", vim.cmd.lbuffer)
vim.keymap.set("n", "<leader>ln", vim.cmd.lnext)
vim.keymap.set("n", "<leader>lp", vim.cmd.lprev)

vim.keymap.set("n", "<leader>th", ":TSToggle highlight<cr>")
vim.keymap.set("n", "<leader>tw", o_toggle("list"))
vim.keymap.set("n", "<leader>tr", o_toggle("relativenumber"))
vim.keymap.set("n", "<leader>tl", o_toggle("number"))
vim.keymap.set("n", "<leader>tc", o_toggle("cursorline"))
vim.keymap.set("n", "<leader>tk", o_cycle("colorcolumn", "", "80"))

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

vim.g.netrw_banner = false

vim.api.nvim_create_autocmd("ColorScheme", { callback = reset_bg })
vim.cmd.colorscheme("vim")
vim.cmd.match("Error", [[/\s\+$/]])
