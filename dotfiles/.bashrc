# Save the current directory in a tmux variable so that new panes start in the
# same directory.
function set_tmux_pwd() {
  [ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D") "$PWD"
}
function cd_internal() {
  \cd $1
  set_tmux_pwd
}
set_tmux_pwd
alias cd=cd_internal

# Source all of the bashrc files you want to use.
source ~/.bashrc_all

# Choose the correct bashrc flavors depending on the current host.
hostname="$(hostname)"
breakout="breakout"
octane="octane"

if [ "$hostname" = "$breakout" ]; then
  source ~/.bashrc_breakout
  source ~/.bashrc_windows
elif [ "$hostname" = "$octane" ]; then
  source ~/.bashrc_octane
  source ~/.bashrc_windows
fi