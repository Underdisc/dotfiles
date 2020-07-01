# Source all of the bashrc files you want to use.
source .bashrc_all

# Choose the correct bashrc flavors depending on the current host.
hostname="$(hostname)"
breakout="breakout"
octane="octane"

if [ "$hostname" = "$breakout" ]; then
    source .bashrc_breakout
    source .bashrc_windows
elif [ "$hostname" = "$octane" ]; then
    source .bashrc_octane
    source .bashrc_windows
fi
