set noswapfile
colorscheme evening
set colorcolumn=81
hi ColorColumn ctermbg=Green
hi Error None

" Allow mouse usage in vim because sometimes I just want to sit back and scroll.
set mouse=a

" Stop vim from wrapping text when performing a git commit.
au FileType gitcommit setlocal tw=0

" Set the filetype of files that are not handled by a default vim install.
au BufNewFile,BufRead *.vs,*.fs,*.glsl set filetype=glsl

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
" hi SpecialKey makes the color of spaces dark blue.
" hi NonText makes the color of eol characters dark blue.
set list
set listchars=tab:>\ ,space:.,nbsp:.,trail:.,eol:~,precedes:<,extends:>
hi SpecialKey ctermfg=4
hi NonText ctermfg=4

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

" Auto insert an ending curly brace and place the cursor on the line between
" the braces.
inoremap {<enter> {<enter>}<esc>kA<enter><tab>

" Ctrl-h|j|k|l will move to a different vim pane.
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Commands for quick file access.
" Changes the working directory to the active file's directory. This will only
" affect the working directory of the selected pane.
nnoremap gcw :lcd %:h<CR>
" Open a different file in the current pane.
nnoremap gce :e<space>**/
nnoremap gcE :E<CR>
" Same as gc* but creates a new pane as a vertical split.
nnoremap gvc :vs<enter><c-w>l
nnoremap gve :vs<enter><c-w>l:e<space>**/
nnoremap gvE :vs<enter><c-w>l:E<enter>
" Same as gv* but creates a horizontal split.
nnoremap ghc :sp<enter><c-w>j
nnoremap ghe :sp<enter><c-w>j:e<space>**/
nnoremap ghE :sp<enter><c-w>j:E<enter>
" Switch to and remove active buffers.
nnoremap gl :ls<enter>:b<space>
nnoremap gr :ls<enter>:bd<space>

" Force the netrw file browser to display all contents of a directory
" alphabetically, but starting with subdirectories.
let g:netrw_sort_sequence = '[\/]$,*'

" Finds all occurences of a string within the working directly recursively.
" A quicklist of the matches will be displayed afterwards.
command -nargs=1 Find :vimgrep /<args>/gj **/* | :belowright copen

" Wrap by word
set linebreak
set eol

" Display status line at the bottom of the terminal.
set laststatus=2
hi StatusLine ctermbg=Black ctermfg=Green

" Run clang-format with ctrl-z. This disables the default behavior of ctrl-z,
" which ends the vim session.
map <c-z> :py3f ~/home/sys/script/clang-format.py<cr>
imap <c-z> <c-o>:py3f ~/home/sys/script/clang-format.py<cr>

" Command for creating a seperator.
command Sep :r ~/.vim/snippets/Separator.txt
