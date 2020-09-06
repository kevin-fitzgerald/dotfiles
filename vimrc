" Set compatability to Vim only.
set nocompatible

" Enable line numbering
set number

" Automatically set new line indentation at the same level as the preceeding line
set autoindent

" Sets default indentation level for autoindent
set shiftwidth=4

" When set, pressing tab results in <softtabstop> spaces being inserted.  If not set, tab chars will be used instead of spaces.
set expandtab

" The number of spaces a tab char equals
set softtabstop=4

" Show partial cmd in status line
set showcmd

" Show matching brackets
set showmatch

" Do case insensitive matching
set ignorecase

" Enable mouse usage
set mouse=a

" Faster scrolling
set ttyfast

" Set vim to use linux system clipboard register
set clipboard=unnamedplus

" Start Vundle Plugin Manager
" See https://github.com/VundleVim/Vundle.vim for Vundle installation details
filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugin List
Plugin 'VundleVim/Vundle.vim' " Required Vundle Plugin
Plugin 'tpope/vim-fugitive' " Git Plugin for Vim
Plugin 'valloric/youcompleteme' " AutoComplete
Plugin 'christoomey/vim-tmux-navigator' " Tmux Window Navigation
Plugin 'scrooloose/nerdtree' " Tree-Style File Browser
Plugin 'raimondi/delimitmate' " Paired brackets
Plugin 'Yggdroot/indentLine' " Vertical allignment displayed with thin lines
Plugin 'chriskempson/base16-vim'

call vundle#end()
filetype plugin indent on
"End Vundle Plugin Manager

" Enable True Color Support for Alacritty
set termguicolors

" Enable syntax highlighting
syntax on

" Enable color scheme
colorscheme base16-default-dark

" Key Binds
silent! nmap <C-p> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>

let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"

" NerdTree autolaunch config
autocmd StdinReadPre * let s:std_in=1
" Open NerdTree if no file is specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NerdTree if a dir is specified
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" Close vim if only NerdTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
