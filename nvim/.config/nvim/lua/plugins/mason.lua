--# selene: allow(mixed_table)
return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "jedi_language_server",
            "lua_ls",
            "ruff",
        },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
