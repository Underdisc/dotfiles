" Disable Bell Sound
set visualbell
set t_vb=

set noswapfile
colorscheme evening

" Highlight search matches.
set hlsearch
hi Search ctermbg=DarkBlue
hi Search ctermfg=Green

" Color Column
set colorcolumn=80
hi ColorColumn ctermbg=Green

" Line endings
set nofixendofline

" Show line number
set number

" Show invisibles as gray.
set list
set listchars=tab:>\ ,space:·,nbsp:.,trail:\ ,eol:~,precedes:<,extends:>
hi SpecialKey ctermfg=Gray

" Tab options
set tabstop=2
set expandtab
set shiftwidth=2
set smartindent

" Display line cursor movments
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$

" Wrap by word
set linebreak
set eol

" Display status line at the bottom of the terminal.
set laststatus=2
hi StatusLine ctermfg=DarkGreen ctermbg=Black
