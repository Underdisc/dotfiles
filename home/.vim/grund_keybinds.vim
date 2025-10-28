" Instead of k and j traversing over a single physical line, they will only
" traverse over visible lines. This makes editing very large wrapped lines
" easier.
nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> 0 g0
nnoremap <silent> $ g$

" alt-h|j|k|l will move to a different vim pane.
execute "set <a-h>=\eh"
execute "set <a-j>=\ej"
execute "set <a-k>=\ek"
execute "set <a-l>=\el"
nnoremap <a-h> <c-w>h
nnoremap <a-j> <c-w>j
nnoremap <a-k> <c-w>k
nnoremap <a-l> <c-w>l

" Copy and pasting from clipboard using Ctrl-p|v and Ctrl-y|c. Ctrl-v is handled
" by the terminal emulator.
nnoremap <c-p> "+p
vnoremap <c-p> "+p
inoremap <c-p> <c-r>*
nnoremap <c-y> "+y
vnoremap <c-y> "+y
nnoremap <c-c> "+y
vnoremap <c-c> "+y

" Visual block is activated with Alt-v in order to avoid conflict with Ctrl-v.
execute "set <a-v>=\ev"
nnoremap <a-v> <c-v>
vnoremap <a-v> <c-v>

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

" Quick write and quit with alt-w|q
execute "set <M-w>=\ew"
execute "set <M-q>=\eq"
nnoremap <M-w> :w<enter>
nnoremap <M-q> :q<enter>
