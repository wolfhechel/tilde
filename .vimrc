" Disables vi compatibility
set nocompatible

filetype plugin indent on

" Enable syntax highlighting, if possible
if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

" Everybody needs a neat colorscheme
colorscheme gruvbox

" Dark background, of course
set background=dark

" Buffer options
set hidden            " Switch between buffers without saving
set autowrite         " Write old file when switching between files
set nobackup          " Don't keep backup files
set noswapfile        " And no swap files either!
set encoding=utf-8    " Use UTF-8 encoding
set lazyredraw        " Don't update the display while executing macros
set noautochdir       " Don't change working dir, use autocmd for that

if v:version >= 730
    set undofile                " Keep a persistent backup file
    set undodir=~/.vim/.undo,~/tmp,/tmp
endif

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
set foldenable
set foldmethod=indent
set foldlevel=99

" Interface options
set number        " Line numbering
set scrolloff=2   " Keep 2 lines margin top and bottom when scrolling
set mousehide     " Hide mouse when typing  
set mouse=a
set title         " Change the terminal's title
set noerrorbells  " Don't beep on error 
set list          " Show unprintable characters
set listchars=tab:»»,trail:·,nbsp:% " Sets up some less obtrusive symbols
set clipboard=unnamedplus " Yank to CLIPBOARD

" Editing options
set showmatch                  " Highlights matching paranthesis
set backspace=indent,eol,start " Allow backspacing over linestops in insert mode
set nomodeline                 " Disables modelines for security
set cursorline                 " Highlights current line
set wildmenu                   " Enable commandline completion
set wildmode=full
set wildignore=.git,*.swp,*.bak,*.py[co],*.class,*.o

" Keymappings
let mapleader="ä"
nmap ö :

" Space clears search highlights
nnoremap <silent> <Space> :nohlsearch<CR>

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

" Emails composed in mutt
augroup muttmail
    autocmd BufRead,BufNewFile        *mutt-* setfiletype mail
augroup END

augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

" Automatically change current directory to that of the file in the buffer
au BufEnter * silent! lcd %:p:h  

" Groovy syntax for gradle files
au BufRead,BufNewFile *.gradle setf groovy

" Never expand tabs when editing Makefiles
au FileType make setlocal noexpandtab

" Autosave files on leaving buffer, leaving insert mode or lost focus
au BufLeave,FocusLost,InsertLeave * silent! wall

if has('gui')
    " Set a decent font
    set guifont=Noto\ Sans\ Mono\ 12

    " Hide the toolbar, why would we want that?
    set guioptions=Acd

    " Disables visualbell
    au GUIEnter * set visualbell t_vb= 
endif

set tags=tags;/

fun! UpdateTags()
    let s:tag_files = tagfiles()

    if len(s:tag_files) > 0
        let s:f = expand("%:p")
        let s:response = system("ctags " . g:ft_ctags_flags . " -a -f " . s:tag_files[0] . " " . s:f)
    endif
endfun

augroup python_spec
    au!
    au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    au FileType python let python_highlight_all = 1
    au FileType python let g:ft_ctags_flags = "--fields=+l --languages=python --python-kinds=-iv --extras=+f"
    autocmd BufWritePost *.py call UpdateTags()
augroup END

