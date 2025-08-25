--# selene: allow(mixed_table)
vim.g.mapleader = ","
vim.g.maploacalleader = ","
vim.g.python3_host_prog = string.gsub(vim.fn.system("which python"), "%s+", "")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    {
        "Yggdroot/indentLine",
        lazy = false,
        init = function()
            vim.g.indentLine_char = "┊"
            -- Avoid conflict with vim-json
            vim.g.indentLine_concealcursor = ""
        end,
    },
    {
        "itchyny/lightline.vim",
        lazy = false,
        init = function()
            vim.g.lightline = {
                colorscheme = "wombat",
                active = {
                    left = {
                        { "mode", "paste" },
                        { "gitbranch", "readonly", "filename", "modified" },
                    },
                },
                component_function = {
                    gitbranch = "FugitiveHead",
                },
            }
        end,
    },
    { "godlygeek/tabular", lazy = false },
    { "jeffkreeftmeijer/vim-numbertoggle", lazy = false },
    -- "maximbaz/lightline-ale",
    { "scrooloose/nerdtree", lazy = false },
    { "terryma/vim-expand-region", lazy = false },
    { "voldikss/vim-floaterm", lazy = false },
    -- File and buffer nav
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
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- tpope
    { "tpope/vim-abolish", lazy = false },
    { "tpope/vim-commentary", lazy = false },
    { "tpope/vim-repeat", lazy = false },
    { "tpope/vim-surround", lazy = false },
    { "tpope/vim-unimpaired", lazy = false },
    -- Git
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
    -- Colors
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
    -- Language Plugins
    -- LSP / Completion / Linting
    --- Load mason.nvim first
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
                    "bashls",
                },
            })
        end,
    },
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        -- dependencies = { "rafamadriz/friendly-snippets" },

        -- use a release tag to download pre-built binaries
        version = "1.*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                preset = "default",
                ["<S-CR>"] = { "select_and_accept" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-l>"] = { "snippet_forward", "fallback" },
                ["<C-h>"] = { "snippet_backward", "fallback" },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                -- Disable auto brackets
                -- NOTE: some LSPs may add auto brackets themselves anyway
                accept = { auto_brackets = { enabled = false } },
                menu = {
                    -- Don't automatically show the completion menu
                    auto_show = true,

                    -- nvim-cmp style menu
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind" },
                        },
                    },
                },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    lsp = {
                        name = "lsp",
                        enabled = true,
                        module = "blink.cmp.sources.lsp",
                        min_keyword_length = 2,
                        score_offset = 90, -- the higher the number, the higher the priority
                    },
                    path = {
                        name = "Path",
                        module = "blink.cmp.sources.path",
                        score_offset = 25,
                        -- When typing a path, I would get snippets and text in the
                        -- suggestions, I want those to show only if there are no path
                        -- suggestions
                        fallbacks = { "snippets", "buffer" },
                        min_keyword_length = 2,
                        opts = {
                            trailing_slash = false,
                            label_trailing_slash = true,
                            get_cwd = function(context)
                                return vim.fn.expand(
                                    ("#%d:p:h"):format(context.bufnr)
                                )
                            end,
                            show_hidden_files_by_default = true,
                        },
                    },
                    buffer = {
                        name = "Buffer",
                        enabled = true,
                        max_items = 3,
                        module = "blink.cmp.sources.buffer",
                        min_keyword_length = 2,
                        score_offset = 15, -- the higher the number, the higher the priority
                    },
                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and
            -- significantly better performance You may use a lua
            -- implementation instead by using `implementation = "lua"` or
            -- fallback to the lua implementation, when the Rust fuzzy matcher
            -- is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport =
                true
            capabilities = vim.tbl_deep_extend(
                "force",
                capabilities,
                require("blink.cmp").get_lsp_capabilities()
            )
            capabilities.offsetEncoding = { "utf-16" }

            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },
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
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- A list of parser names, or "all". These will be installed immediately.
                ensure_installed = {
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
                },
                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = true,
                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = false,
                ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
                -- parser_install_dir = "/some/path/to/store/parsers",
                -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
                indent = { enable = true },
                highlight = {
                    enable = true,
                    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                    -- the name of the parser)
                    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 * 1024 -- 100 MB
                        local ok, stats = pcall(
                            vim.loop.fs_stat,
                            vim.api.nvim_buf_get_name(buf)
                        )
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
    -- C/C++
    { "rhysd/vim-clang-format", ft = "cpp" },
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
    -- Python
    -- Web
    { "elzr/vim-json", ft = "json" },
    { "hail2u/vim-css3-syntax", ft = { "css", "html" } },
    { "leafgarland/typescript-vim", ft = "typescript" },
    { "mattn/emmet-vim", ft = "html" },
    { "pangloss/vim-javascript", ft = "javascript" },
    -- Rust
    {
        "simrat39/rust-tools.nvim",
        ft = "rust",
        config = function()
            local rt = require("rust-tools")
            rt.setup({
                server = {
                    on_attach = function(_, bufnr)
                        -- Hover actions
                        vim.keymap.set(
                            "n",
                            "<C-space>",
                            rt.hover_actions.hover_actions,
                            { buffer = bufnr }
                        )
                        -- Code action groups
                        vim.keymap.set(
                            "n",
                            "<Leader>a",
                            rt.code_action_group.code_action_group,
                            { buffer = bufnr }
                        )
                    end,
                },
            })
        end,
    },
    -- Etc
    { "chrisbra/csv.vim", ft = "csv" },
    { "lervag/vimtex", ft = "tex" },
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
    {
        "preservim/vim-markdown",
        ft = "markdown",
        init = function()
            vim.g.vim_markdown_folding_disabled = 1
        end,
    },
}, {
    ui = {
        border = "rounded",
    },
})

vim.o.swapfile = true
vim.o.history = 100
vim.opt.ffs = { "unix", "dos", "mac" }

vim.o.mouse = "nvi"
vim.o.number = true
vim.o.wrap = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 5
vim.o.ruler = true
vim.o.cmdheight = 2
vim.o.foldcolumn = "1"

vim.o.langmenu = "en"
vim.o.wildmenu = true
vim.o.wildignore =
    "*.o,*~,*.pyc,__pycache__,/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store"
-- Better backspace behavior
vim.o.backspace = "eol,start,indent"
-- Allow to move from beginning of line to end of previous line, etc.
vim.opt.whichwrap:append("<>hl")

-- Don't redraw while executing a macro
vim.o.lazyredraw = true
-- Less backslashes in regex patterns
vim.o.magic = true
-- Show matching brackets and blink for 2/10 of second when showing match
vim.o.showmatch = true
vim.o.matchtime = 2
-- No sounds or flashes on error
vim.o.errorbells = false
vim.o.visualbell = false

-- Time in ms before a key sequence is considered complete
vim.o.timeoutlen = 500

-- Always show the tablilne
vim.o.stal = 2

vim.o.hlsearch = true
-- Search for pattern as it is typed
vim.o.incsearch = true

vim.o.background = "dark"
-- vim.cmd.colorscheme("peaksea")

vim.o.writebackup = false
-- Turn persistent undo on
vim.fn.system("mkdir -p $HOME/.vim/undodir//")
vim.o.undodir = vim.fn.expand("~/.vim/undodir//")
vim.o.undofile = true

vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- Set line length indicator
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "c",
        "cpp",
        "css",
        "java",
        "javascript",
        "lua",
        "markdown",
        "python",
        "rust",
        "sh",
        "tex",
        "vim",
        "zsh",
    },
    command = "set colorcolumn=80",
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html" },
    command = "set colorcolumn=120",
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "csv", "text", "tsv", "svg", "ps", "postscr", "help" },
    command = "set colorcolumn=",
})
-- Return to last edit position when opening files
vim.cmd(
    [[autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
)

-- Fix gq[q] behavior
-- Use internal formatting for bindings like gq.
-- ref: https://vi.stackexchange.com/questions/39200/wrapping-comment-in-visual-mode-not-working-with-gq
-- ref: https://github.com/neovim/neovim/pull/19677
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.bo[args.buf].formatexpr = nil
    end,
})

-- ======================
--  = M A P P I N G S =
-- ======================
-- Pressing ,ss will toggle and untoggle spell checking
vim.keymap.set("n", "<Leader>ss", ":setlocal spell!<cr>")
-- Toggle paste mode on and off
vim.keymap.set("n", "<Leader>pp", ":setlocal paste!<cr>")
-- floatterm
vim.keymap.set("n", "<Leader>fn", ":FloatermNew<CR>")
vim.keymap.set("n", "<F8>", ":FloatermToggle<CR>", { silent = true })
vim.keymap.set(
    "t",
    "<F8>",
    [[<C-\><C-n>:FloatermToggle<CR>]],
    { silent = true }
)

-- telescope
local tsb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tsb.find_files, {})
vim.keymap.set("n", "<leader>fg", tsb.live_grep, {})

-- Auto complete tags
vim.keymap.set("i", "<lt>//", "</<C-x><C-o><Esc>==gi", { noremap = true })

-- ======================
-- -> Visual Mode Related
-- ======================
-- vim.keymap.set("x", "<Leader>s", 'xi""<Esc>P')

-- =======================
-- -> Command Mode Related
-- =======================
-- Bash like keys for the command line
vim.keymap.set("c", "<C-A>", "<Home>", { noremap = true })
vim.keymap.set("c", "<C-E>", "<End>", { noremap = true })
vim.keymap.set("c", "<C-K>", "<C-U>", { noremap = true })

-- ===========
-- -> Movement
-- ===========
vim.keymap.set({ "n", "v", "o" }, "<space>", "/")
-- Change windows
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-l>", "<C-W>l")

-- Jump to diagnostic messages
vim.keymap.set(
    "n",
    "[d",
    vim.diagnostic.goto_prev,
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "]d",
    vim.diagnostic.goto_next,
    { noremap = true, silent = true }
)

-- ==============
-- -> Status Line
-- ==============
function PasteModeStr()
    if vim.o.paste then
        return "PASTE MODE  "
    end
    return ""
end
-- Status line always on
vim.o.laststatus = 2
-- Set statusline in case no LightLine
vim.opt.statusline =
    " %{v:lua.PasteModeStr()}%F%m%r%h %w  CWD: %r%{getcwd()}%h   Line: %l  Column: %c"
if vim.g.loaded_lightline then
    -- Don't show mode if LightLine is active
    vim.o.showmode = false
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})
vim.diagnostic.config({
    virtual_text = {
        source = true,
        format = function(diagnostic)
            return string.format("%s - %s", diagnostic.code, diagnostic.message)
        end,
    },
})

-- This must be placed after loading plugins
require("colorizer").setup()
