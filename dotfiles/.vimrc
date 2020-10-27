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

" After pressing enter, the new line will be auto indented to match the
" indentation of the above line.
set autoindent

" Instead of k and j traversing over a single physical line, they will only
" traverse over visible lines. This makes editing very large wrapped lines
" easier.
nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> 0 g0
nnoremap <silent> $ g$

" Auto instert ending an curly brace and place the cursor on the line between
" the braces.
inoremap {<Enter> {<Enter>}<Esc>kA<Enter><Tab>

" Wrap by word
set linebreak
set eol

" Display status line at the bottom of the terminal.
set laststatus=2
hi StatusLine ctermbg=Black ctermfg=Green

" Run clang-format on ctrl-k.
map <C-K> :pyf ~/home/sys/script/clang-format.py<cr>
imap <C-K> :pyf ~/home/sys/script/clang-format.py<cr>
