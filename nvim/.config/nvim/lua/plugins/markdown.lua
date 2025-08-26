--# selene: allow(mixed_table)
return {
    {
        "preservim/vim-markdown",
        ft = "markdown",
        init = function()
            vim.g.vim_markdown_folding_disabled = 1
        end,
    },
}
