set t_Co=256
set notermguicolors
set background=dark


" Auto-install vim-plug if not already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" list plugins here
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'preservim/nerdtree'
call plug#end()

" vim specific rules here
syntax on
filetype plugin indent on
highlight SignColumn guibg=NONE ctermbg=NONE
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set nocompatible
set wildmenu
set wildmode=longest,list,full
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set backspace=indent,eol,start
set incsearch
set scrolloff=5
let g:limelight_conceal_ctermfg = 240
let g:airline_theme = 'minimalist'
let g:airline_powerline_fonts = 1
let g:ctrlp_show_hidden = 1
let NERDTreeShowHidden = 1
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
runtime! macros/matchit.vim
nnoremap <C-n> :NERDTreeToggle<CR>

" coc.nvim rules here
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Down> coc#pum#visible() ? coc#pum#next(1) : "\<Down>"

inoremap <silent><expr> <Up> coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"

let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-json',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-pyright',
    \ 'coc-phpls',
    \ 'coc-pairs'
    \ ]
