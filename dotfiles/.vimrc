
set nocompatible

filetype plugin indent on


call plug#begin('~/.vim/plugged')

" Zig syntax highlighting
Plug 'ziglang/zig.vim'
" Auto pairs
Plug 'jiangmiao/auto-pairs'
" Bulk commenting
Plug 'tomtom/tcomment_vim'

" File tree (optional, better than netrw)
" Plug 'preservim/nerdtree'

" Fuzzy finder (optional)
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

call plug#end()


" Basic Settings

" Line numbers
" set number
" set relativenumber

" No delay when pressing keys
set timeout timeoutlen=200 ttimeoutlen=0
" Scrolling padding (cursor stays 8 lines from edge)
set scrolloff=8

" Highlight current line
set cursorline

" Show command in bottom bar
set showcmd

" Visual autocomplete for command menu
set wildmenu

" Highlight matching brackets
set showmatch

" Search settings
set incsearch       " Search as you type
set hlsearch        " Highlight search results
set ignorecase      " Case insensitive search
set smartcase       " Case sensitive if uppercase present

" Tab settings
set showtabline=0
" set tabstop=4       " Visual spaces per TAB
" set softtabstop=4   " Spaces in tab when editing
" set shiftwidth=4    " Spaces for autoindent
" set expandtab       " Tabs are spaces

" Indentation
set autoindent
set smartindent

" Line wrapping
set wrap
set linebreak

" Show hidden characters (optional)
set list
set listchars=tab:▸\ ,trail:·

" Auto-save when switching buffers
set autowrite
set autowriteall

" Backup and swap files (disable for cleaner workspace)
set nobackup
set nowritebackup
set noswapfile

" Undo file (persistent undo)
set undofile
set undodir=~/.vim/undo

" Split settings
set splitbelow
set splitright

" Status line
set laststatus=2
set statusline=%F%m%r%h%w\ [%l/%L,%v]\ [%p%%]

" Mouse support (optional)
set mouse=a

" Clipboard (use system clipboard)
set clipboard=unnamedplus

" Colors
set background=dark
colorscheme desert  " Built-in colorscheme

" ============================================
" File Explorer (netrw built-in)
" ============================================

" Open file explorer
nnoremap <leader>e :Explore<CR>

" netrw settings
let g:netrw_banner=0        " Disable banner
let g:netrw_liststyle=3     " Tree view
let g:netrw_browse_split=4  " Open in previous window
let g:netrw_altv=1
let g:netrw_winsize=25

" ============================================
" Keybindings
" ============================================

" Set leader key to space
let mapleader = " "

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Clear search highlight
nnoremap <leader>h :nohlsearch<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprev<CR>
nnoremap <leader>d :bdelete<CR>

" Toggle file explorer
nnoremap <leader>e :Lexplore<CR>

" ============================================
" Language-specific settings
" ============================================

" C
autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab

" Python
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

" Go (uses tabs by convention)
autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab

" Zig
autocmd FileType zig setlocal tabstop=4 shiftwidth=4 expandtab

" Java
autocmd FileType java setlocal tabstop=4 shiftwidth=4 expandtab

" ============================================
" Auto-commands
" ============================================

" Create undo directory if it doesn't exist
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p", 0700)
endif

" Return to last edit position when opening files
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Auto-save on focus lost
autocmd FocusLost * silent! wa

" ============================================
" Syntax highlighting for specific languages
" ============================================

" Enable better C syntax highlighting
let c_comment_strings=1
let c_gnu=1
let c_space_errors=1

" Python syntax
let python_highlight_all=1
