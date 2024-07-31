require('trouble').setup({
  icons = {
    indent = {
      middle = "├╴ ",
      last = "└ ",
      top = "│ ",
      ws = "  ",
      fold_open = "▾ ",
      fold_closed = "▸ ",
    },
  },
  modes = {
    diagnostics = {
      groups = {
        { "filename", format = "{basename:Title} {count}" },
      },
    },
  },
})

vim.cmd("set scl=no")
