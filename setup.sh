#!/bin/bash
# Usage: ./setup.sh <fullpath_to_home>
# fullpath_to_home is the full path to your home directory (~/)
# For example: C:/cygwin64/home/underdisc

home_full_path=$1
script_full_path=$(realpath "$0")
script_dir=$(dirname "$script_full_path")

# This will allow us to account for dotfiles. Dotfiles are not
# extracted from a directory in a shell script by default.
shopt -s dotglob

# Create a symlink for every entry in dotfiles/. Existing files are overwritten.
for repo_dotfile in $script_dir/dotfiles/*; do
  home_dotfile=$home_full_path/$(basename $repo_dotfile)
  if [ -f "$home_dotfile" ] || [ -L "$home_dotfile" ]; then
    rm $home_dotfile
  fi
  ln -s $repo_dotfile $home_dotfile
done

shopt -u dotglob
