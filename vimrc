" -----------------------------------------------------------------------------
" Sections:
"    == Plugin Management
"    -> General
"    -> Editor Interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Command mode related
"    -> Moving
"    -> Status line
"    -> Editing mappings
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"    => Filetype Settings
"       * Python
"    => Plugin Config
" -----------------------------------------------------------------------------


" =========================
" === Plugin Management ===
" =========================
call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'mattn/emmet-vim'
Plug 'junegunn/goyo.vim'
Plug 'amix/vim-zenroom2'
Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'junegunn/limelight.vim'
Plug 'godlygeek/tabular'
Plug 'terryma/vim-expand-region'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
" Snippets and Completion
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
if has('python3')
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
" tpope
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
" Colors
Plug 'vim-scripts/mayansmoke'
Plug 'junegunn/seoul256.vim'
Plug 'fbunt/peaksea'
Plug 'altercation/vim-colors-solarized'
" Language Plugins
Plug 'aliou/bats.vim'
Plug 'chrisbra/csv.vim'
Plug 'ap/vim-css-color'
Plug 'hail2u/vim-css3-syntax'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'hdima/python-syntax'
Plug 'nvie/vim-flake8'
Plug 'rust-lang/rust.vim'
Plug 'elzr/vim-json'

call plug#end()


" ==========
" -> General
" ==========
set nocompatible
set swapfile
set autoread
set history=100
" Unix as standard file type
set ffs=unix,dos,mac

let mapleader = ','

filetype on
filetype plugin on
filetype indent on


" ===================
" -> Editor Interface
" ===================
set number
set nowrap
" More natural feeling window spliting
set splitbelow
set splitright
" TODO: only turn on when needed and/or make filetype dependent
set colorcolumn=80
" Leave lines above/below cursor when moving vertically
set scrolloff=5
" Show line,col
set ruler
set cmdheight=2
" Add extra margin to left of folds
set foldcolumn=1

let $LANG='en'
set langmenu=en
" Wild command completion
set wildmenu
set wildignore=*.o,*~,*.pyc
set wildignore+=/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
" Better backspace behavior
set backspace=eol,start,indent
" Allow to move from beginning of line to end of previous line, etc.
set whichwrap+=<,>,h,l

" Case insensitive search
"set ignorecase
"set smartcase

" Don't redraw while executing a macro
set lazyredraw
" Less backslashes in regex patterns
set magic
" Show matching brackets and blink for 2/10 of second when showing match
set showmatch
set matchtime=2
" No sounds or flashes on error
set noerrorbells
set novisualbell
set t_vb=

" Time in ms before a key sequence is considered complete 
set timeoutlen=500

" Always show the tablilne 
set stal=2
set tabline=%!CustomizedTabLine()


" ==================
" -> Search Settings
" ==================
set hlsearch
" Search for pattern as it is typed
set incsearch

" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
    let g:ackprg = 'ag --vimgrep --smart-case'
endif


" =================
" -> Colors & Fonts
" =================
syntax enable
set background=dark
colorscheme peaksea

" Enable 256 color palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

"try
"    colorscheme desert
"catch
"endtry


set encoding=utf8


" ========================
" -> Files, Backups & Undo
" ========================
set nowritebackup
" Turn persistent undo on 
try
    set undodir=~/.vim/undodir
    set undofile
catch
endtry

" TODO: turn off features for large files


" =====================
" -> Text, Tab & Indent
" =====================
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4


" ======================
" -> Visual Mode Related
" ======================
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


" =======================
" -> Command Mode Related
" =======================
" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>


" ===========
" -> Movement
" ===========
map <space> /
" Change windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" ==============
" -> Status Line
" ==============
" Status line always on
set laststatus=2
" Set statusline in case no LightLine
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
if get(g:, 'loaded_lightline', 0)
    " Don't show mode if LightLine is active
    set noshowmode
endif


" ===================
" -> Editing Mappings
" ===================
" Remap 0 to go to first non blank character
" TODO: may be able to use _ instead
"map 0 ^

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" Auto complete tags
inoremap <lt>// </<C-x><C-o><Esc>==gi


" -> Spell Checking
" =================
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>


" =======
" -> Misc
" =======
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


" ===================
" -> Helper Functions
" ===================
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

function! CustomizedTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let s .= '%' . i . 'T'
        let s .= (i == t ? '%1*' : '%2*')
        let s .= ' '
        let s .= i . ':'
        let s .= '%*'
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
        let file = bufname(buflist[winnr - 1])
        let file = fnamemodify(file, ':p:t')
        if file == ''
            let file = '[No Name]'
        endif
        let s .= file
        let s .= ' '
        let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
endfunction



" ====================
" => Filetype Settings
" ====================
" ** Python **
let python_highlight_all = 1
au FileType python set cindent
au FileType python syn keyword pythonDecorator True None False self



" ================
" => Plugin Config
" ================

" ** lightline **
" ===============
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified', 'cwd'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], ['filetype'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
      \ },
      \ 'component_function': {
      \   'cwd': 'LightLineCWD',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': '|' }
      \ }

function! LightLineCWD()
    let cwd = getcwd()
    if cwd == '/'
        return cwd
    endif
    let dirlist = split(cwd, '/')
    if len(dirlist)
        return dirlist[-1] . '/'
    else
        return './'
    endif
endfunction


" ** Zen/Goyo **
" ==============
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!


" ** ALE **
" =========
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_highlights = 1
" Move to next/previous error
nmap <silent> <C-N> <Plug>(ale_next_wrap)
nmap <silent> <C-M> <Plug>(ale_previous_wrap)

let g:ale_linters = {
\   'javascript': ['jshint', 'eslint'],
\   'python': ['flake8'],
\   'go': ['go', 'golint', 'errcheck'],
\   'rust': ['cargo']
\}


" ** IndentLine **
" ================
let g:indentLine_char = '.'
" Avoid conflict with vim-json
let g:indentLine_concealcursor=""

" ** Git Gutter **
" ===============
let g:gitgutter_enabled=1
nnoremap <silent> <leader>d :GitGutterToggle<cr>


" ** NerdTree **
" ==============
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
map <leader>nn :NERDTreeToggle<cr>


" ** deoplete **
" ==============
let g:deoplete#enable_at_startup = 1
