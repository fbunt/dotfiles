--# selene: allow(mixed_table)
return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" }, -- default = '│'
                    change = { text = "~" }, -- default = '│'
                    delete = { text = "_" }, -- default = '_'
                    topdelete = { text = "‾" }, -- default = '‾'
                    changedelete = { text = "~" }, -- default = '~'
                    untracked = { text = "┆" }, -- default = '┆'
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })
                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })
                end,
            })
        end,
    },
    { "tpope/vim-fugitive", lazy = false },
}
