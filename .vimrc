" Disables vi compatibility
set nocompatible

set runtimepath+=~/.cache/vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/vim/dein')
    call dein#begin('~/.cache/vim/dein')

    call dein#add('~/.cache/vim/dein/repos/github.com/Shougo/dein.vim')

    call dein#add('morhetz/gruvbox')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')

    call dein#end()
    call dein#save_state()
endif

" Enable the filetype plugin, remain compatible with older versions
if has('autocmd')
    filetype plugin indent on
endif

" Enable syntax highlighting, if possible
if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

if dein#check_install()
    call dein#install()
endif

" Everybody needs a neat colorscheme
colorscheme gruvbox

" Dark background, of course
set background=dark

" Airline options
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'gruvbox'

" Buffer options
set hidden            " Switch between buffers without saving
set autowrite         " Write old file when switching between files
set nobackup          " Don't keep backup files
set noswapfile        " And no swap files either!
set switchbuf=useopen " Show already opened files in quickfix window instead
                      " of ropening them
set encoding=utf-8    " Use UTF-8 encoding
set lazyredraw        " Don't update the display while executing macros
set history=1000      " Remember more commands and search history
set undolevels=1000   " Deeper undo list
set noautochdir       " Don't change working dir, use autocmd for that

if v:version >= 730
    set undofile                " Keep a persistent backup file
    set undodir=~/.vim/.undo,~/tmp,/tmp
endif

" Ignored file globs when expanding wildcards
set wildignore=.git,*.swp,*.bak,*.pyc,*.class,*.o

" Search options
set incsearch  " Show search matches as we're typing
set hlsearch   " Highlight search terms
set ignorecase " Ignore case when searching
set smartcase  " Ignore case-sensitivity if search is all lower-case

" Indentation options
set tabstop=4     " A tab is four columns wide
set expandtab     " Expand tabs into appropriate
set softtabstop=4 " A tab is expanded into 4 spaces
set shiftwidth=4  " Indenting is expanded into 4 spaces
set autoindent    " Automatically indent the next line
set copyindent    " Copy the previous indentation on autoindent
set shiftround    " Use multiples of shiftwidth when <> indenting

" Text wrapping options
set textwidth=79        " Line max-length hint
set wrap                " Wrap text
set formatoptions=qrnl  " Options for text-wrapping/-formatting (:help fo-tables)

if v:version >= 704 || (v:version == 703 && has('patch541'))
    " Merge comment lines
    set formatoptions+=j 
endif

" Interface options
set number        " Line numbering
set ruler         " Shows current cursor position in lower right corner
set showcmd       " Show command in bottom right portion of screen
set laststatus=2  " Always show the status line
set noshowmode    " We got vim-airline for this now
set scrolloff=2   " Keep 2 lines margin top and bottom when scrolling
set mousehide     " Hide mouse when typing  
set mouse=a       " Enable using mouse if terminal supports it
set title         " Change the terminal's title
set noerrorbells  " Don't beep on error 
set list          " Show unprintable characters
set listchars=tab:»»,eol:¶,trail:·,nbsp:% " Sets up some less obtrusive symbols

" Editing options
set showmatch                  " Highlights matching paranthesis
set backspace=indent,eol,start " Allow backspacing over linestops in insert mode
set pastetoggle=<F2>           " Toggle paste with F2
set nomodeline                 " Disables modelines for security
set cursorline                 " Highlights current line
set foldenable                 " Enable folding

" Keymappings

" Set a sane leader key
let mapleader=","

" Space clears search highlights
nnoremap <silent> <Space> :nohlsearch<CR>

" Switch between buffers
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprev<CR>

" Remap j and k to move line by line, even on long lines
nnoremap j gj
nnoremap k gk

if has('autocmd')
    " Marks characters spanning further than 79 on a single line
    augroup vimrc_autocmds
        au CursorMovedI,CursorMoved,BufRead * highlight OverLength ctermbg=darkgrey guibg=#592929
        au CursorMovedI,CursorMoved,BufRead * match OverLength /\%79v.*/
    augroup END

    " Reload vimrc file after saving
    augroup myvimrchooks
        au!
        au BufWritePost .vimrc source ~/.vimrc
    augroup END

    " Disables visualbell, this is done here because the GUI has to be loaded
    au GUIEnter * set visualbell t_vb= 

    " Automatically change current directory to that of the file in the buffer
    au BufEnter * silent! lcd %:p:h  

    au BufRead,BufNewFile *.sls set ft=yaml ts=4 sts=4 sw=4
    au BufRead,BufNewFile *.gradle setf groovy

    " Never expand tabs when editing Makefiles
    au FileType make setlocal noexpandtab

    " Autosave files on leaving buffer, leaving insert mode or lost focus
    au BufLeave,FocusLost,InsertLeave * silent! wall
endif
