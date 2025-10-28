#!/bin/bash
# Usage: ./setup.sh <fullpath_to_home>?
# fullpath_to_home: The full path to your home directory. If not included, ~ is
#   used as the default.

home_path=$(realpath ~)
if [ ! -z $1 ]; then
  home_path=$1
fi
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

ensure_dirs() {
  local dirs=$1
  for dir in $dirs; do
    if [ ! -d "$dir" ]; then
      mkdir "$dir"
    fi
  done
}

symlink_home_files() {
  for entry_path in $(find $script_dir/home -printf '%P\n' | sort); do
    local repo_entry_path=$script_dir/home/$entry_path
    local home_entry_path=$home_path/$entry_path

    # Create a directory at home if it doesn't exist.
    if [ -d "$repo_entry_path" ]; then
      ensure_dirs "$home_entry_path"
      continue
    fi

    # Create a symlink for the entry.
    if [ -f "$home_entry_path" ] || [ -L "$home_entry_path" ]; then
      rm "$home_entry_path"
    fi
    ln -s "$repo_entry_path" "$home_entry_path"
  done
}

symlink_git_number_files() {
  local git_number_files="git-id git-list git-number"
  for git_number_entry in $git_number_files; do
    local repo_entry_path="$script_dir/sub/git-number/$git_number_entry"
    local bin_entry_path="$home_path/.local/bin/$git_number_entry"
    if [ -f "$bin_entry_path" ] || [ -L "$bin_entry_path" ]; then
      rm "$bin_entry_path"
    fi
    ln -s "$repo_entry_path" "$bin_entry_path"
  done
}

# shopt will allow us to account for dotfiles. Dotfiles are not extracted from a
# directory in a shell script by default.
shopt -s dotglob
symlink_home_files
shopt -u dotglob

ensure_dirs "$home_path/.local $home_path/.local/bin"
symlink_git_number_files
