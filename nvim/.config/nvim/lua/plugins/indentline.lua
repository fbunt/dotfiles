--# selene: allow(mixed_table)
return {
    {
        "Yggdroot/indentLine",
        lazy = false,
        init = function()
            vim.g.indentLine_char = "┊"
            -- Avoid conflict with vim-json
            vim.g.indentLine_concealcursor = ""
        end,
    },
}
