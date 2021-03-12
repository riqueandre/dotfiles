
" Vim-plug Automatic installation
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" pluggins dir
call plug#begin(stdpath('data') . '/plugged')
	Plug 'sonph/onehalf', { 'rtp': 'vim' }
call plug#end()

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif


colorscheme onehalfdark
syntax on
filetype plugin indent on
set cursorline
set hidden 
set number
set tabstop=4                           " Number of visual spaces per TAB
set softtabstop=4                       " Number of spaces in tab when editing
set shiftwidth=4	                    " On pressing tab, insert 4 spaces
set expandtab                           " Tabs are spaces
set textwidth=0                         " Hard-wrap long lines as you type them.
set modeline                            " Enable modeline.
set nojoinspaces                        " Prevents inserting two spaces after punctuation on a join (J)
set splitbelow                          " Horizontal split below current.
set splitright                          " Vertical split to right of current.
set noerrorbells                        " No beeps
set noswapfile                          " Don't use swapfile
set nobackup            	            " Don't create annoying backup files
set encoding=utf-8                      " Set default encoding to UTF-8
set autowrite                           " Automatically save before :next, :make etc.
set autoread                            " Automatically reread changed files without asking me anything