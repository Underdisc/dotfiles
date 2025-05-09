set noswapfile
colorscheme rainbow

" Vertical bar.
set colorcolumn=81
au BufNewFile,BufRead *.md,*.txt,*.tex,gitcommit set colorcolumn=
au FileType gitcommit set colorcolumn=

" Spellchecking
command Spellen set spell spelllang=en_us
command Spellde set spell spelllang=de
command Spellno set nospell

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

" Show Line Numbers
set relativenumber

" Show Invisibles
set list
set listchars=tab:>\ ,space:.,nbsp:.,trail:.,eol:~,precedes:<,extends:>

" Tabs are two spaces wide and pressing tab inserts two spaces by default.
set softtabstop=2
set shiftwidth=2
set expandtab

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

" Ctrl-h|j|k|l will move to a different vim pane.
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Copy and pasting from clipboard using Ctrl-p|v
nnoremap <c-p> "+p
vnoremap <c-p> "+p
inoremap <c-p> <c-r>*
vnoremap <c-y> "+y

" Apply and remove indents with tab and shift-tab in visual and normal modes.
nnoremap <tab> >l
vnoremap <tab> > gv
nnoremap <s-tab> <h
vnoremap <s-tab> < gv

" Faster fundamental motions.
nnoremap <s-h> 5h
nnoremap <s-j> 5j
nnoremap <s-k> 5k
nnoremap <s-l> 5l

vnoremap <s-h> 5h
vnoremap <s-j> 5j
vnoremap <s-k> 5k
vnoremap <s-l> 5l

" Easier exit mapping.
nnoremap <c-e> <c-[>
inoremap <c-e> <c-[>
vnoremap <c-e> <c-[>

" Easier quit mapping.
nnoremap <c-q> :q<enter>

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

" An easier way to apply the last used macro.
nnoremap , @@

" Force the netrw file browser to display all contents of a directory
" alphabetically, but starting with subdirectories.
let g:netrw_sort_sequence = '[\/]$,*'

" Finds all occurences of a string within the working directly recursively.
" A quicklist of the matches will be displayed afterwards.
command -nargs=1 Find :vimgrep /<args>/gj **/* | :belowright copen

" Word wrapping
set linebreak
set eol
set showbreak=

" Display status line at the bottom of the terminal.
set laststatus=2

" Run clang-format with ctrl-z. This disables the default behavior of ctrl-z,
" which ends the vim session.
map <c-z> :py3f ~/home/sys/win64/script/clang-format.py<cr>
imap <c-z> <c-o>:py3f ~/home/sys/win64/script/clang-format.py<cr>

" Command for creating a seperator.
command Sep :r ~/.vim/snippets/Separator.txt

function Dnd()
  vs
  e stats.md
  vertical resize 32
  wincmd l
  e live.md
  vs
  vertical resize 32
  sp
  resize 10
  wincmd j
  e equipment.md
  wincmd l
  e quest.md
endfunction
command Dnd :call Dnd()
