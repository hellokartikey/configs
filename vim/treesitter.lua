-- Treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "c",
      "cpp",
      "cmake",
      "make",
      "python",
      "diff",
      "html",
      "css",
      "javascript",
      "qmljs",
    },
    sync_install = false,
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
})

-- Treesitter colors
vim.api.nvim_set_hl(0, "@variable", { cterm=none, ctermfg=4 })
vim.api.nvim_set_hl(0, "@variable.builtin", { link="@variable" })
vim.api.nvim_set_hl(0, "@variable.parameter.builtin", { link="@variable" })

vim.api.nvim_set_hl(0, "@constant", { cterm=none, ctermfg=3 })
vim.api.nvim_set_hl(0, "@constant.builtin", { link="@constant" })

vim.api.nvim_set_hl(0, "@module", { cterm=none, ctermfg=12 })
vim.api.nvim_set_hl(0, "@module.builtin", { link="@module" })

vim.api.nvim_set_hl(0, "@string", { cterm=none, ctermfg=10 })
vim.api.nvim_set_hl(0, "@string.escape", { link="@string" })
vim.api.nvim_set_hl(0, "@string.regexp", { link="@string" })
vim.api.nvim_set_hl(0, "@string.special", { link="@string" })
vim.api.nvim_set_hl(0, "@string.special.url", { link="@string" })

vim.api.nvim_set_hl(0, "@character", { link="@constant" })
vim.api.nvim_set_hl(0, "@character.special", { link="@constant" })

vim.api.nvim_set_hl(0, "@boolean", { link="@constant" })
vim.api.nvim_set_hl(0, "@number", { link="@constant" })
vim.api.nvim_set_hl(0, "@number.float", { link="@constant" })

vim.api.nvim_set_hl(0, "@type", { bold=true, ctermfg=10 })
vim.api.nvim_set_hl(0, "@type.builtin", { link="@type" })

vim.api.nvim_set_hl(0, "@attribute", { cterm=none, ctermfg=11 })
vim.api.nvim_set_hl(0, "@attribute.builtin", { link="@attribute" })
vim.api.nvim_set_hl(0, "@property", { cterm=none, ctermfg=10 })

vim.api.nvim_set_hl(0, "@function", { cterm=none, ctermfg=6 })
vim.api.nvim_set_hl(0, "@function.builtin", { link="@function" })
vim.api.nvim_set_hl(0, "@constructor", { link="@function" })

vim.api.nvim_set_hl(0, "@keyword", { italic=true, bold=true, ctermfg=3 })

vim.api.nvim_set_hl(0, "@label", { underline=true, bold=true, ctermfg=7 })

vim.api.nvim_set_hl(0, "@operator", { cterm=none, ctermfg=7 })

vim.api.nvim_set_hl(0, "@punctuation", { cterm=none, ctermfg=7 })
vim.api.nvim_set_hl(0, "@punctuation.special", { link="@punctuation" })

vim.api.nvim_set_hl(0, "@comment", { bold=true, ctermfg=7 })
