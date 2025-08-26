--# selene: allow(mixed_table)
return {
    {
        "nvimdev/guard.nvim",
        dependencies = { "nvimdev/guard-collection" },
        event = "BufReadPre",
        config = function()
            local ft = require("guard.filetype")
            ft("c,cpp"):fmt("clang-format"):lint("clang-tidy")
            ft("json"):fmt("clang-format")
            ft("lua"):fmt({
                cmd = "stylua",
                args = { "-s", "-" },
                stdin = true,
            })

            vim.g.guard_config = {
                fmt_on_save = false,
                -- Use lsp if no formatter was defined for this filetype
                lsp_as_default_formatter = true,
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "c", "cpp", "json", "lua", "python", "rust" },
                callback = function()
                    vim.keymap.set("n", "<Leader>bb", ":Guard fmt<cr>")
                end,
            })
        end,
    },
}
