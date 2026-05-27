require('nvim-treesitter').setup {
    ensure_installed = { "norg", "query", "verilog", "c", "lua", "python", "markdown", "markdown_inline", "vim", "vimdoc" },

    prefer_git = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    auto_install = true,
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },
}
