--# selene: allow(mixed_table)
return {
    { "fbunt/peaksea", priority = 100000 },
    { "altercation/vim-colors-solarized", lazy = false },
    { "junegunn/seoul256.vim", lazy = false },
    { "morhetz/gruvbox" },
    { "vim-scripts/mayansmoke" },
    { "guns/xterm-color-table.vim", lazy = false },
    { "fynnfluegge/monet.nvim", name = "monet" },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = {
                    light = "latte",
                    dark = "mocha",
                },
                dim_inactive = {
                    enabled = true, -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15, -- percentage of the shade to apply to the inactive window
                },
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    native_lsp = {
                        enabled = true,
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        },
                    },
                },
                custom_highlights = function(colors)
                    return {
                        LineNr = { fg = colors.overlay1 },
                        WinSeparator = { fg = colors.sapphire },
                    }
                end,
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    "norcalli/nvim-colorizer.lua",
}
