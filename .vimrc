" Disables vi compatibility
set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'VundleVim/Vundle.vim'
Plug 'morhetz/gruvbox'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'ycm-core/YouCompleteMe', { 'do': 'python install.py'}
Plug 'tpope/vim-surround'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'liuchengxu/vista.vim'
Plug 'dense-analysis/ale'
Plug 'jeetsukumaran/vim-pythonsense'

call plug#end()

filetype plugin indent on

runtime ftplugin/man.vim

" Enable syntax highlighting, if possible
if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

" Everybody needs a neat colorscheme
colorscheme gruvbox

" Dark background, of course
set background=dark

" Airline options
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'gruvbox'

" Enable rainbow globally
let g:rainbow_active = 1

" Disable ALE completion
let g:ale_completion_enabled = 0

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_auto_trigger = 1

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
set splitbelow        " Split windows bellow

if v:version >= 730
    set undofile                " Keep a persistent backup file
    set undodir=~/.vim/.undo,~/tmp,/tmp
endif

" Ignored file globs when expanding wildcards
set wildignore=.git,*.swp,*.bak,*.pyc,*.class,*.o,,

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
set formatoptions=qrnlj " Options for text-wrapping/-formatting (:help fo-tables)

" Folding options
set foldmethod=indent
set foldlevel=99

" Interface options
set number        " Line numbering
set laststatus=2  " Always show the status line
set noshowmode    " We got vim-airline for this now
set scrolloff=2   " Keep 2 lines margin top and bottom when scrolling
set mousehide     " Hide mouse when typing  
set mouse=a       " Enable using mouse if terminal supports it
set title         " Change the terminal's title
set noerrorbells  " Don't beep on error 
set list          " Show unprintable characters
set listchars=tab:»»,eol:¶,trail:·,nbsp:% " Sets up some less obtrusive symbols
set clipboard=unnamedplus " Yank to CLIPBOARD

" Editing options
set showmatch                  " Highlights matching paranthesis
set backspace=indent,eol,start " Allow backspacing over linestops in insert mode
set pastetoggle=<F4>           " Toggle paste with F4
set nomodeline                 " Disables modelines for security
set cursorline                 " Highlights current line
set foldenable                 " Enable folding
set wildmenu                   " Enable commandline completion
set wildmode=full

" Keymappings
let mapleader="ä"
nmap ö :

nmap <Leader>a :NERDTreeToggle<CR>
nmap <Leader>s :Vista<CR>
nmap <leader>g :YcmCompleter GoToDefinition<CR>

" Space clears search highlights
nnoremap <silent> <Space> :nohlsearch<CR>

" Ctrl+Space folds code
nnoremap <silent> <space> za

" Switch between buffers
nnoremap <C-j> :bprev<CR>
nnoremap <C-k> :bnext<CR>

" Remap j and k to move line by line, even on long lines
nnoremap j gj
nnoremap k gk

" Unmap recording, it's probably really useful but wrong key
map q <Nop>

" Mark characters spanning further than 79 characters on a single line
highlight ColorColumn ctermbg=darkgrey
call matchadd('ColorColumn', '\%79v.*', 100)

augroup lastcursor
    au!

    " Returning to last known cursor position
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" Reload vimrc file after saving
augroup reloadvimrc
    au!
    au BufWritePost .vimrc source ~/.vimrc
augroup END

" Transparent editing of gpg encrypted files.
augroup encrypted
    au!
    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg set bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
    autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
    autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg set nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg set bin
    autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
    autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
    autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --encrypt --default-recipient-self 2>/dev/null
    autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost  *.gpg silent u
    autocmd BufWritePost,FileWritePost  *.gpg set nobin
augroup END

" Automatically change current directory to that of the file in the buffer
au BufEnter * silent! lcd %:p:h  

" Use YAML syntax for salt state files
au BufRead,BufNewFile *.sls set ft=yaml ts=4 sts=4 sw=4

" Groovy syntax for gradle files
au BufRead,BufNewFile *.gradle setf groovy

" Never expand tabs when editing Makefiles
au FileType make setlocal noexpandtab

" Autosave files on leaving buffer, leaving insert mode or lost focus
au BufLeave,FocusLost,InsertLeave * silent! wall

au FileType python nnoremap <buffer> <C-r> :! python %<CR>

if has('gui')
    " Set a decent font
    set guifont=Noto\ Sans\ Mono\ 12

    " Hide the toolbar, why would we want that?
    set guioptions=Acd

    " Disables visualbell
    au GUIEnter * set visualbell t_vb= 
endif

function RefactorName()
    call inputsave()
    let new_name = input('refactor: ')
    call inputrestore()

    execute ":YcmCompleter RefactorRename " . new_name .""
endfunction

nnoremap <Leader>r :call RefactorName()<CR>

py3 << EOF
import os
import vim

virtual_env = os.environ.get('VIRTUAL_ENV', None)

if virtual_env:
    interpreter = os.path.join(virtual_env, 'bin', 'python')

    vim.command('let g:ycm_python_binary_path = "%s"' % interpreter)

EOF
