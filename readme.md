# dotfiles
A place to keep, maintain, and share my dotfiles.

# Before you clone
Make sure you set autocrlf to false in your git config so the line endings of files aren't changed when they are cloned. `git config --global core.autocrlf false` will handle it.

# After cloning
This repo contains git submodules. Before proceeding with the setup script, run `git submodule update --init --recursive`.

# setup.sh
There is a shell script called `setup.sh` in the root of this repo. Run it like this.

`setup.sh <fullpath_to_home>`

`fullpath_to_home` should be the full path to your home directory (`~/`). Mine is `C:/cygwin64/home/underdisc` for my cygwin setup.

This will take all of the files within `dotfiles/` and create soft symlinks for them inside of your home directory. The symlinks will point to your local copy of the files within this repo.

**Warning:** If a file or symlink within your home directory has the same name as one within `dotfiles/`, the file will be deleted so the new symlink file can have the filename.

# start.bat
This bat file is intended to be used as a startup file for windows. It should show up in the `Startup` tab of the task manager when placed in the correct directory. On my machine, this directory is `C:/Users/[YourUserDir]/AppData/Roaming/Microsoft/Windows/"Start Menu"/Programs/Startup`. Just create a windows shortcut or symlink to the bat file within that directory.

# tmux
When launching tmux, tmux will not automatically look at `.tmux.conf` for your configuration settings. To get those settings working, run the following from your home directory before launching tmux.

`tmux source-file .tmux.conf`

