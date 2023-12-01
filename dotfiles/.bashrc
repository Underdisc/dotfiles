# Source all of the bashrc files.
pushd ~ >/dev/null
source .bashrc_all
hostname=$(hostname)
if [[ $hostname =~ breakout ]]; then
  source .bashrc_breakout
elif [[ $hostname =~ octane ]]; then
  source .bashrc_octane
elif [[ $hostname =~ Joey-Guesktop ]]; then
  source .bashrc_joey-guesktop
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