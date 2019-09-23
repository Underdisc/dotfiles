" Disable Bell Sound
set visualbell
set t_vb=

" Colorscheme
colorscheme evening
hi SpecialKey ctermfg=LightMagenta

" Color Column
set colorcolumn=80

" Show line number
:set number

" Show invisibles
:set list
:set listchars=tab:>\ ,space:.,nbsp:.,trail:\ ,eol:~,precedes:<,extends:>

" Make leading spaces more noticable
highlight WhiteSpaceBol ctermfg=Magenta
highlight WhiteSpaceMol ctermfg=DarkGray
match WhiteSpaceMol / /
2match WhiteSpaceBol /^ \+/

" Tab options
:set tabstop=4
:set expandtab
:set shiftwidth=4
:set smartindent

" Wrap by word
:set linebreak

" Disable swap files
set noswapfile
