--# selene: allow(mixed_table)
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            -- Parsers to install (async; no-op for already-installed ones).
            -- Requires the tree-sitter CLI and a C compiler.
            require("nvim-treesitter").install({
                "bash",
                "c",
                "cpp",
                "html",
                "java",
                "javascript",
                "json",
                "lua",
                "python",
                "rst",
                "rust",
                "terraform",
                "vim",
                "vimdoc",
                "yaml",
            })

            -- The main branch has no highlight/indent modules; enable
            -- treesitter per buffer from a FileType autocmd instead.
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterStart", {}),
                callback = function(args)
                    local buf = args.buf
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang then
                        return
                    end
                    -- Skip treesitter for large files
                    local max_filesize = 100 * 1024 * 1024 -- 100 MB
                    local ok, stats = pcall(
                        vim.uv.fs_stat,
                        vim.api.nvim_buf_get_name(buf)
                    )
                    if ok and stats and stats.size > max_filesize then
                        return
                    end
                    -- Fails quietly when no parser is installed for lang
                    if pcall(vim.treesitter.start, buf, lang) then
                        vim.bo[buf].indentexpr =
                            "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
}
