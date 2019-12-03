# dotfiles
Just a place to keep my dotfiles.

# dotfiles/bashrc\_flavors
I have multiple flavors of bashrc in `bashrc_flavors/`. This is for things that are machine specific and will need manual setup.

# dotfiles/windows
These dotfiles are specifically for windows machines. For example, there is a file called `.ahk` in this diretory. That is an auto hotkey script and auto hotkey is only intended for use on windows.

# setup.sh
There is a shell script called `setup.sh` in the root of this repo. Run it like this.

`setup.sh <fullpath_to_home>`

`fullpath_to_home` should be the full path to your home directory (`~/`). Mine is `C:/cygwin64/home/underdisc` for my cygwin setup.

This will take all of the files within `dotfiles/` and create soft symlinks for them inside of your home directory. It will not create a symlink for `.bashrc`. It will just copy that file. This copy should be modified to source the wanted bashrc flavors. The symlinks will point to your local copy of the files within this repo. It also won't create symlinks for anything inside of `dotfiles/bashrc_flavors` or `dotfiles/windows`. This must be done manually since they might not work on the machine being set up.

**Warning:** If a file or symlink within your home directory has the same name as one within `dotfiles/`, the file will be deleted so the new symlink file can have the filename.

# start.bat
This bat file is intended to be used as a startup file for windows. It should show up in the `Startup` tab of the task manager when placed in the correct directory. On my machine, this directory is `C:/Users/[YourUserDir]/AppData/Roaming/Microsoft/Windows/"Start Menu"/Programs/Startup`. Just create a windows shortcut to the bat file within that directory.

# tmux
When launching tmux, tmux will not automatically look at `.tmux.conf` for your configuration settings. To get those settings working, run the following from your home directory before launching tmux.

`tmux source-file .tmux.conf`

