--# selene: allow(mixed_table)
return {
    {
        "hashivim/vim-terraform",
        ft = "terraform",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "terraform",
                callback = function()
                    vim.keymap.set("n", "<Leader>bb", ":TerraformFmt<cr>")
                end,
            })
        end,
    },
}
