return {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function()
        require("hover").setup({
            providers = {
                "hover.providers.lsp",
                "hover.providers.man",
                "hover.providers.dictionary",
            },
            preview_opts = {
                border = "single",
            },
            preview_window = false,
            title = true,
        })
    end,
    keys = {
        {
            "K",
            function()
                require("hover").hover()
            end,
            desc = "Hover docs",
        },
    },
}
