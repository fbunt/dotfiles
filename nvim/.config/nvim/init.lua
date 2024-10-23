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
    -- Snippets and Completion
    {
        "ervandew/supertab",
        lazy = false,
        init = function()
            vim.g.SuperTabDefaultCompletionType = "<C-n>"
            vim.g.SuperTabClosePreviewOnPopupClose = 1
        end,
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
    "neovim/nvim-lspconfig",
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
                auto_install = true,
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
                    vim.keymap.set("n", "<Leader>bb", ":GuardFmt<cr>")
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

local lspconfig = require("lspconfig")
lspconfig.ruff.setup({
    on_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        -- local bufopts = { noremap = true, silent = true, buffer = bufnr }
        -- vim.keymap.set("n", "<Leader>bb", function()
        --     vim.lsp.buf.format({ async = true })
        -- end, bufopts)
    end,
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
        },
    },
})

-- This must be placed after loading plugins
require("colorizer").setup()
