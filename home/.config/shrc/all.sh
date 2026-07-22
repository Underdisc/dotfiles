source .config/shrc/git.sh
hostname=$(hostname)
if [[ $hostname =~ breakout ]]; then
  source .config/shrc/breakout_locals.sh
elif [[ $hostname =~ octane ]]; then
  source .config/shrc/octane_locals.sh
elif [[ $hostname =~ takumi ]]; then
  source .config/shrc/takumi_locals.sh
elif [[ $hostname =~ dominus ]]; then
  source .config/shrc/dominus_locals.sh
fi

if [[ $hostname =~ breakout ]]; then
  export MOZ_USE_XINPUT2=1
fi

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
alias archive="rsync $base_rsync_flags"
alias reflect="rsync $base_rsync_flags --delete"

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l --time-style=long-iso'
alias lla='ls -la'

yz() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

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

# Save the current directory in a tmux variable so that we can start new panes
# in the same directory.
function set_tmux_pwd() {
  if [ -n "$TMUX" ]; then
    tmux setenv TMUXPWD_$(tmux display -p "#D") "$PWD"
    tmux rename-window "$(echo $PWD | sed 's|^/home/[[:alnum:]]\+|~|')"
  fi
}
function cd_internal() {
  cd "$1"
  set_tmux_pwd
}
set_tmux_pwd
alias cd=cd_internal

# Go to ~ when not in a tmux session.
if [ ! -n "$TMUX" ]; then
  cd ~
fi
