set noswapfile
colorscheme evening
set colorcolumn=80
hi ColorColumn ctermbg=Green

" Disable Bell Sound
set visualbell
set t_vb=

" Highlight search matches.
set hlsearch
hi Search ctermbg=DarkBlue
hi Search ctermfg=Green

" Line endings
set nofixendofline

" Show gray line numbers.
set number
hi LineNr cterm=bold ctermfg=0

" Show invisibles in gray.
" hi SpecialKey makes the color of spaces gray.
" hi NonText makes the color of eol characters gray.
set list
set listchars=tab:>\ ,space:.,nbsp:.,trail:.,eol:~,precedes:<,extends:>
hi SpecialKey cterm=bold ctermfg=0
hi NonText cterm=bold ctermfg=0

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
hi StatusLine ctermbg=Black ctermfg=Green

" Plugin Options
" Change the indent markers from the indentLine plugin to green.
let g:indentLine_color_term=2

