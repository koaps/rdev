set nocompatible
filetype off

" set mouse=a
set mouse=

" Look for tags file in current file dir upwards. Failing that, it will
" look for the file in .git/tags
set tags=./tags;,.git/tags

" Don't go back to beginning of file when scanning/search
"set nowrapscan

set nopaste

"turn on airline status bar
set laststatus=2

"set textwidth=79  " lines longer than 79 columns will be broken

set hidden
set wrap        " don't wrap lines
set tabstop=2     " a tab is 2 spaces
set softtabstop=4 " insert/delete 2 spaces when hitting a TAB/BACKSPACE

set backspace=indent,eol,start
                    " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set cindent
"set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
"set ignorecase    " ignore case when searching
"set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                    "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set visualbell           " don't beep
set noerrorbells         " don't beep

set nobackup
"set noswapfile

" nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<leader>p

set list
set listchars=tab:\ \ ,trail:.,extends:>,precedes:<,nbsp:.
"set listchars=tab:→\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨

set expandtab     " don't use actual tab character

" Show column rulers
" set colorcolumn=72,80

" bind K to grep word under cursor
nnoremap K yiw:Ag<SPACE><C-R>0<CR>

" set bind for numbers
map ` <Nop>
nmap ` :set number! number?<cr>
nmap <silent> ,/ :nohlsearch<CR>

" Execute current file
nnoremap <Leader>r :!%:p

set showmode

set t_u7=
set t_RV=
