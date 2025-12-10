--# selene: allow(mixed_table)
return {
    {
        "williamboman/mason.nvim",
        opts = {},
        config = function()
            require("mason").setup()
        end,
    },
    -- Then load mason-lspconfig.nvim after mason.nvim
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        version = "1.*",
        pin = true,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "jedi_language_server",
                    "ruff",
                },
            })
        end,
    },
}
