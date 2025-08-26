--# selene: allow(mixed_table)
return {
    {
        "itchyny/lightline.vim",
        lazy = false,
        init = function()
            vim.g.lightline = {
                colorscheme = "wombat",
                active = {
                    left = {
                        { "mode", "paste" },
                        { "gitbranch", "readonly", "filename", "modified" },
                    },
                },
                component_function = {
                    gitbranch = "FugitiveHead",
                },
            }
        end,
    },
}
