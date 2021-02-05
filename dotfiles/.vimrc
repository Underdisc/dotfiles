set noswapfile
colorscheme evening
set colorcolumn=81
hi ColorColumn ctermbg=Green

" Set the filetype of files that are not handled by a default vim install.
au BufNewFile,BufRead *.vs,*.fs set filetype=glsl

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

" Automatically read an open file if it has been changed outside of vim after
" running checktime. The full functionality of autoread does not work with
" tmux on cygwin.
set autoread

" Instead of k and j traversing over a single physical line, they will only
" traverse over visible lines. This makes editing very large wrapped lines
" easier.
nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> 0 g0
nnoremap <silent> $ g$

" Auto instert ending an curly brace and place the cursor on the line between
" the braces.
inoremap {<enter> {<enter>}<esc>kA<enter><tab>

" Ctrl-h|j|k|l will move to a different vim pane.
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Commands for quick file access that also allow for opening files inside of
" new splits.
nnoremap gc :e<space>**/
nnoremap gv :ls<enter>:bd<space>
nnoremap gb :ls<enter>:b<space>
nnoremap gs :vs<enter><c-w>l:e<space>**/
nnoremap gh :sp<enter><c-w>j:e<space>**/

" Wrap by word
set linebreak
set eol

" Display status line at the bottom of the terminal.
set laststatus=2
hi StatusLine ctermbg=Black ctermfg=Green

" Run clang-format with ctrl-z. This disables the default behavior of ctrl-z,
" which ends the vim session.
map <c-z> :pyf ~/home/sys/script/clang-format.py<cr>
imap <c-z> :pyf ~/home/sys/script/clang-format.py<cr>
