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
    { "ervandew/supertab", lazy = false },
    -- tpope
    { "tpope/vim-abolish", lazy = false },
    { "tpope/vim-commentary", lazy = false },
    { "tpope/vim-repeat", lazy = false },
    { "tpope/vim-surround", lazy = false },
    { "tpope/vim-unimpaired", lazy = false },
    -- Git
    {
        "airblade/vim-gitgutter",
        lazy = false,
        init = function()
            vim.g.gitgutter_enabled = 1
            vim.keymap.set(
                "n",
                "<leader>d",
                ":GitGutterToggle<cr>",
                { silent = true, noremap = true }
            )
        end,
    },

    { "tpope/vim-fugitive", lazy = false },
    -- Colors
    { "fbunt/peaksea", lazy = false, priority = 100000 },
    { "altercation/vim-colors-solarized", lazy = false },
    { "junegunn/seoul256.vim", lazy = false },
    { "morhetz/gruvbox", lazy = false },
    { "vim-scripts/mayansmoke", lazy = false },
    { "guns/xterm-color-table.vim", lazy = false },
    -- Language Plugins
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-lint",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
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

            require("guard").setup({
                -- the only options for the setup function
                fmt_on_save = false,
                -- Use lsp if no formatter was defined for this filetype
                lsp_as_default_formatter = true,
            })
        end,
    },
    -- Python
    {
        "vim-python/python-syntax",
        ft = { "python" },
        init = function()
            vim.g.python_highlight_all = 1
        end,
    },
    -- Web
    { "ap/vim-css-color", lazy = false },
    { "elzr/vim-json", ft = "json" },
    { "hail2u/vim-css3-syntax", ft = { "css", "html" } },
    { "leafgarland/typescript-vim", ft = "typescript" },
    { "mattn/emmet-vim", ft = "html" },
    { "pangloss/vim-javascript", ft = "javascript" },
    -- Rust
    { "simrat39/rust-tools.nvim", ft = "rust" },
    -- Etc
    { "chrisbra/csv.vim", ft = "csv" },
    { "lervag/vimtex", ft = "tex" },
    { "hashivim/vim-terraform", ft = "terraform" },
    { "preservim/vim-markdown", ft = "markdown" },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        build = ":TSUpdate",
    },
}, {})

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
vim.o.noerrorbells = true
vim.o.novisualbell = true
vim.o.t_vb = ""

-- Time in ms before a key sequence is considered complete
vim.o.timeoutlen = 500

-- Always show the tablilne
vim.o.stal = 2

vim.o.hlsearch = true
-- Search for pattern as it is typed
vim.o.incsearch = true

vim.o.background = "dark"
vim.cmd.colorscheme("peaksea")

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
lspconfig.ruff_lsp.setup({
    on_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "<Leader>bb", function()
            vim.lsp.buf.format({ async = true })
        end, bufopts)
    end,
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
        },
    },
})
require("lint").linters_by_ft = {
    lua = { "selene" },
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

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

require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "java",
        "javascript",
        "json",
        "lua",
        "python",
        "rust",
        "vim",
        "vimdoc",
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers",
    -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 * 1024 -- 100 MB
            local ok, stats =
                pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
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
vim.cmd([[
    highlight GitGutterAdd    guifg=#009900 guibg=#202020 ctermfg=2 ctermbg=NONE
    highlight GitGutterChange guifg=#bbbb00 guibg=#202020 ctermfg=3 ctermbg=NONE
    highlight GitGutterDelete guifg=#ff2222 guibg=#202020 ctermfg=1 ctermbg=NONE
]])
