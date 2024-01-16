-- Treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "arduino",
      "bash",
      "latex",
      "dockerfile",
      "lua",
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
      "vim",
      "xml",
      "toml",
      "yaml"
    },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
})

