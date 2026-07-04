alias gin='git number -s'

alias gch='git number checkout'
alias ga='git number add'
alias gap='git number add --patch'
alias grm='git number rm'
alias gu='git number restore --staged'

alias gcm='git commit'
alias gcmm='git commit -m'
alias gcma='git commit --amend'

alias gawc='git add . && git commit -m "wc"'
alias grwc='git reset HEAD~1'

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

alias gla='git log --graph --all --abbrev-commit --color=always --decorate --date=format:%g-%m-%d --format=tformat:"%w(80, 0, 2)%C(bold)%C(white){%C(#00dddd)%h%C(white)|%C(#ee44ff)%ad%C(white)|%C(#44ee44)%an%C(#ffaa22)|%D%C(white)} %s"'
alias gls='gla -10'
alias gll='gla -40'
alias glal='gla | less -r'
function cgls(){
  clear
  gls
}
function cgll(){
  clear
  gll
}

alias gl='gls'
alias cgl='cgls'

function gs(){
  git show --color=always $1 | delta --paging never
}
function gsl(){
  git show --color=always $1 | delta --paging always
}
function glame(){
  git blame -s --color-lines $1 | less -r
}
