" Instead of k and j traversing over a single physical line, they will only
" traverse over visible lines. This makes editing very large wrapped lines
" easier.
nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> 0 g0
nnoremap <silent> $ g$

" alt-a|s will create splits
execute "set <a-a>=\ea"
execute "set <a-s>=\es"
nnoremap <a-a> :vsplit<cr>
nnoremap <a-s> :split<cr>

" alt-h|j|k|l will move to a different vim pane.
execute "set <a-h>=\eh"
execute "set <a-j>=\ej"
execute "set <a-k>=\ek"
execute "set <a-l>=\el"
nnoremap <a-h> <c-w>h
nnoremap <a-j> <c-w>j
nnoremap <a-k> <c-w>k
nnoremap <a-l> <c-w>l

" alt-)|5|6|7 will swap adjacent windows.
" Inspired by https://stackoverflow.com/a/12870073
function! SwapWindows(direction)
  " Note the current window
  let l:currentWinNum = winnr()
  let l:currentBufNum = bufnr("%")
  " Switch to other window in the given direction
  exe "wincmd " . a:direction
  let l:otherWinNum = winnr()
  let l:otherBufNum = bufnr("%")
  " Swap the buffers displayed in the window
  exe l:currentWinNum . 'wincmd w'
  exe 'buffer ' . otherBufNum
  exe l:otherWinNum . 'wincmd w'
  exe 'buffer ' . currentBufNum
endfunction
nnoremap <m-s-0> :call SwapWindows('h')<cr>
nnoremap <m-5>   :call SwapWindows('j')<cr>
nnoremap <m-6>   :call SwapWindows('k')<cr>
nnoremap <m-7>   :call SwapWindows('l')<cr>

" alt-w|q|x to write, close buffer, or close window
execute "set <a-w>=\ew"
execute "set <a-q>=\eq"
execute "set <a-x>=\ex"
nnoremap <a-w> :write<enter>
nnoremap <a-q> :Bdelete<enter>
nnoremap <a-x> :close<enter>

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
