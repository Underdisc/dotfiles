alias gin='git number -s'

alias gch='git number checkout'
alias ga='git number add'
alias gap='git number add --patch'
alias grm='git number rm'
alias gu='git number restore --staged'

alias gcm='git commit'
alias gcma='git commit --amend'

function gd(){
  git number diff --color=always $1 | delta --paging never
}
function gdl(){
  git number diff --color=always $1 | delta --paging always
}

alias gf='git number -c clang-format -style=file -i'
function gfd(){
  gf $1
  gd $1
}
function gfdl(){
  gf $1
  gdl $1
}

function gds(){
  git number diff --staged --color=always $1 | delta --paging never
}
function gdsl(){
  git number diff --staged --color=always $1 | delta --paging always
}

alias gls='git lgs'
alias gll='git lgl'
alias gla='git lga'
alias glal='git lga | less -r'
function cgls(){
  clear
  gls
}
function cgll(){
  clear
  gll
}

function gsh(){
  git show --color=always $1 | delta --paging never
}
function gshl(){
  git show --color=always $1 | delta --paging always
}
function glame(){
  git blame -s --color-lines $1 | less -r
}
