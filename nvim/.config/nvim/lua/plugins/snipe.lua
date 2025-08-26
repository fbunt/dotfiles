--# selene: allow(mixed_table)
return {
    {
        -- Find buffers
        "leath-dub/snipe.nvim",
        keys = {
            {
                "<leader>fb",
                function()
                    require("snipe").open_buffer_menu()
                end,
                desc = "Open Snipe buffer menu",
            },
        },
        opts = {},
    },
}
