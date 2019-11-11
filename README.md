# dotfiles
Just a place to keep my dotfiles.

# setup
There is a shell script called `setup.sh` in the root of this repo. Run it like this.

`setup.sh <fullpath_to_home>`

`fullpath_to_home` should be the full path to your home directory (`~/`). Mine is `C:/cygwin64/home/underdisc` for my cygwin setup.

This will take all of the files within `dotfiles/` and create soft symlinks for them inside of your home directory. The only file that will not be a symlink in `.bashrc`. It is just a copy. The symlinks will point to your local copy of the files within this repo.

**Warning:** If a file or symlink within your home directory has the same name as one within `dotfiles/`, the file will be deleted so the new symlink file can have the filename.

# tmux
When launching tmux, tmux will not automatically look at `.tmux.conf` for your configuration settings. To get those settings working, run the following from your home directory before launching tmux.

`tmux source-file .tmux.conf`

# bashrc\_flavors
I have multiple flavors of bashrc in `bashrc_flavors/`. This is for things that are machine specific and will need manual setup.
