# Source all of the bashrc files.
pushd ~ >/dev/null
source .config/bashrc/all.sh
source .config/bashrc/git.sh
hostname=$(hostname)
if [[ $hostname =~ breakout ]]; then
  source .config/bashrc/windows.sh
elif [[ $hostname =~ octane ]]; then
  source .config/bashrc/octane_locals.sh
elif [[ $hostname =~ takumi ]]; then
  source .config/bashrc/takumi_locals.sh
elif [[ $hostname =~ dominus ]]; then
  source .config/bashrc/dominus_locals.sh
fi
popd >/dev/null

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
