#!/bin/sh

# Usage: ./setup.sh <fullpath_to_home>
# fullpath_to_home is the full path to your home directory (~/)
# For example: C:/cygwin64/home/underdisc

destination_dir=$1
source_dir="dotfiles"
script_dir=$PWD

# This will allow us to account for dotfiles. Dotfiles are not
# extracted from a directory in a shell script by default.
shopt -s dotglob

cd $destination_dir
for source_fullpath in $script_dir/$source_dir/*; do
    # We ignore all directories.
    if [ -d "$source_fullpath" ]; then
        continue;
    fi
    
    # Remove a file in the destination if it occupies the name for the new
    # symlink and create the symlink.
    filename=`basename $source_fullpath`
    destination_fullpath=$destination_dir/$filename
    if [ -f "$destination_fullpath" ] || [ -L "$destination_fullpath" ]; then
        rm $destination_fullpath
    fi

    if [ $filename == ".bashrc" ]; then
        cp $source_fullpath $filename
    else
        ln -s $source_fullpath $filename
    fi
done
cd $script_dir
shopt -u dotglob
