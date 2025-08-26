--# selene: allow(mixed_table)
return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                lua = { "selene" },
            }
            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWritePost", "InsertLeave" },
                {
                    callback = function()
                        require("lint").try_lint()
                    end,
                }
            )
        end,
    },
}
