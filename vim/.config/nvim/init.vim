set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

let g:python3_host_prog = substitute(system("which python3"), '\n\+$', '', '')
source ~/.vim/vimrc
