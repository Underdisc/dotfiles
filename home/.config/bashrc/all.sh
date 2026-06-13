# Create a prompt that looks like this with some different colors for each field.
# user@hostname ~/dir$
export PS1="\[\033[1;92m\]\u\[\033[1;97m\]@\[\033[1;95m\]\h \
\[\033[1;94m\]\w\[\033[1;97m\]$ \[\033[0m\]"

bind '"\C-\b": backward-kill-word'

export HISTTIMEFORMAT="|%g-%m-%d|%H:%M| "
shopt -s histappend
HISTSIZE=-1
HISTFILESIZE=-1

# Set environment variables
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export PAGER="less"
export GTK_THEME=Adwaita:dark

alias home='cd ~/home'
alias dl='cd ~/home/download/new'
alias nb='node build.js'
alias rmd='rm -rf'
alias diff='diff --color'
alias lapdf='latex -c-style-errors -output-format=pdf'
alias rsyncd='rsync --daemon --no-detach'
base_rsync_flags='--human-readable --recursive --times --modify-window=3 --devices --links --specials --verbose --itemize-changes --progress'
alias archive='rsync $base_rsync_flags'
alias reflect='rsync $base_rsync_flags --delete'
alias nv='nvim'
alias yz='yazi'

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l --time-style=long-iso'
alias lla='ls -la'

btop() {
  hostname=$(hostname)
  config_dir=~/.config/btop
  system_config=$config_dir/system.conf
  cat $config_dir/btop.conf > $system_config
  if [ -f $config_dir/$hostname.conf ]; then
    cat $config_dir/$hostname.conf >> $system_config
  fi
  command btop --config $system_config --preset 0
}

mkcd()
{
  mkdir $1
  cd $1
}

eval "$(fzf --bash)"
eval "$(zoxide init bash)"
