if has('vim_starting')
    " Disables vi compatibility
    set nocompatible

    set rtp+=~/.vim/bundle/neobundle.vim/
endif

try
    call neobundle#begin(expand('~/.vim/bundle/'))

    NeoBundle 'Shougo/neobundle.vim'
    NeoBundle 'Shougo/vimproc.vim', {
        \ 'build' : {
        \     'mac' : 'make -f make_mac.mak',
        \     'unix' : 'make -f make_unix.mak',
        \    },
        \ }

    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'bling/vim-airline'
    NeoBundle 'tpope/vim-surround'
    NeoBundle 'SirVer/ultisnips'
    NeoBundle 'honza/vim-snippets'
    NeoBundle 'Valloric/YouCompleteMe' , {
        \ 'build' : {
        \   'unix' : './install.sh --clang-completer'
        \ }
    \ }

    NeoBundle 'jalcine/cmake.vim'
    NeoBundle 'Raimondi/delimitMate'
    NeoBundle 'scrooloose/syntastic'
    NeoBundle 'majutsushi/tagbar'

    call neobundle#end()

    NeoBundleCheck
catch
    echom "Could not find NeoBundle, make sure you've checked it out into .vim/bundle/NeoBundle.vim"
endtry

nnoremap <leader>j :Unite file_rec/async<cr>i<cr>

let g:UltiSnipsExpandTrigger="<c-o>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsListSnippets="<nop>"

let g:ycm_extra_conf_globlist = ['~/.ycm_extra_conf.py']

imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"

" Enable the filetype plugin, remain compatible with older versions
if has('autocmd')
    filetype plugin indent on
endif

" Everybody needs a neat colorscheme
colorscheme darkspectrum

" Enable syntax highlighting, if possible
if has('syntax') && !exists('g:syntax_on')
    syntax on
endif

" First, set a sane leader key
let mapleader=","

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
set noautochdir

if v:version >= 730
    set undofile                " Keep a persistent backup file
    set undodir=~/.vim/.undo,~/tmp,/tmp
endif

set wildignore=.git,*.swp,*.bak,*.pyc,*.class,*.o " Ignored file globs when expanding
                                         " wildcards

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

" Options applied if we're running in a GUI
if has('gui_running')
    " Set a decent font
    try
        set guifont=Source\ Code\ Pro\ Medium\ 11
    catch
        set guifont=Source\ Code\ Pro\ Medium:h11
    endtry

    " Hide the toolbar, why would we want that?
    set guioptions-=T
endif

" Editing options
set showmatch                  " Highlights matching paranthesis
set backspace=indent,eol,start " Allow backspacing over linestops in insert mode
set pastetoggle=<F2>           " Toggle paste with F2
set nomodeline                 " Disables modelines for security
set cursorline                 " Highlights current line

" Code folding options
set foldenable 

"
" Keymappings
"

" Space clears search highlights
nnoremap <silent> <Space> :nohlsearch<CR>

" And in normal mode, bind to command (since I'm Swedish)
nnoremap ö :

" Increment number below cursor
nnoremap + <C-a>

" Decrement number below cursor
nnoremap - <C-x>

" Faster navigation through paragraphs (in Insert mode)
inoremap <C-j> <C-o>}
inoremap <C-k> <C-o>{

" Faster navigation through paragraphs (in normal mode)
nnoremap <C-j> }
nnoremap <C-k> {

" Remap j and k to move line by line, even on long lines
nnoremap j gj
nnoremap k gk

" Move one word at a time
nnoremap <C-h> b
nnoremap <C-l> w

" Disable navigation through arrowkeys, just to avoid the habit
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Replace visually selected python code with the output
vnoremap <silent> <C-e>p :!python<cr>

" Toggle LustyJuggler
map <leader>l :LustyJuggler<CR>

" Show buffer of file without hashcomments
nnoremap <leader>c :g!/^#

" Append and prepend to line
nnoremap <leader>p i<C-o>$
nnoremap <leader>a i<C-o>^

" Save file with elevated privileges
cmap w!! w !sudo tee % >/dev/null

if has('autocmd')
    " Marks characters spanning further than 79 on a single line
    augroup vimrc_autocmds
        autocmd CursorMovedI,CursorMoved,BufRead * highlight OverLength ctermbg=darkgrey guibg=#592929
        autocmd CursorMovedI,CursorMoved,BufRead * match OverLength /\%79v.*/
    augroup END

    " Reload vimrc file after saving
    augroup myvimrchooks
        au!
        autocmd BufWritePost .vimrc source ~/.vimrc
    augroup END

    " Disables visualbell, this is done here because the GUI has to be loaded
    autocmd GUIEnter * set visualbell t_vb= 
    " Automatically change current directory to that of the file in the buffer
    autocmd BufEnter * cd %:p:h  

    " Restore cursor position from previous session
    fun! GotoLastPosition()
        let ignored = ['COMMIT_EDITMSG']
        let last_position = line("'\"")

        if index(ignored, &ft)
            return
        endif

        if last_position > 1 && last_position < line("$")
            exe "normal! g`\""
        endif
    endfun

    au BufReadPost * call GotoLastPosition()
    au BufRead,BufNewFile *.sls set ft=yaml ts=4 sts=4 sw=4
    au BufRead,BufNewFile *.gradle setf groovy

    " In insert mode, something easier than reaching for <ESC>
    au BufEnter * exec "inoremap <silent> <c-i> <esc><cr>"

    " Never expand tabs when editing Makefiles
    autocmd FileType make setlocal noexpandtab

    " Autosave files on leaving buffer, leaving insert mode or lost focus
    autocmd BufLeave,FocusLost,InsertLeave * silent! wall
endif

" Occasionally, I mess up
iab imoprt import
