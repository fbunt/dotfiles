-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maploacalleader = ","
vim.g.python3_host_prog = string.gsub(vim.fn.system("which python"), "%s+", "")

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

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
}, {
    ui = {
        border = "rounded",
    },
})

-- telescope
local tsb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tsb.find_files, {})
vim.keymap.set("n", "<leader>fg", tsb.live_grep, {})

-- Formatting
-- Disable the built-in formatter so StyLua can take over
require("lspconfig").lua_ls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "json", "lua", "python", "rust" },
    callback = function()
            vim.keymap.set("n", "<Leader>bb", function()
                local ft = vim.bo.filetype

                if ft == "lua" then
                    require("stylua-nvim").format_file()
                else
                    vim.lsp.buf.format({ async = false })
                end
            end, { buffer = true })
    end,
})
