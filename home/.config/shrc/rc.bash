# Create a prompt that looks like this with some different colors for each field.
# user@hostname ~/dir$
export PS1="\[\033[1;92m\]\u\[\033[1;97m\]@\[\033[1;95m\]\h \
\[\033[1;94m\]\w\[\033[1;97m\]$ \[\033[0m\]"

bind '"\C-\b": backward-kill-word'

export HISTTIMEFORMAT="|%g-%m-%d|%H:%M| "
shopt -s histappend
HISTSIZE=-1
HISTFILESIZE=-1

alias nv='nvim'

eval "$(fzf --bash)"
eval "$(zoxide init bash)"

