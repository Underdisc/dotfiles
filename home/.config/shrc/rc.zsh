# Use vi mode.
bindkey -v

# Use Ctrl-n to edit current line in a text editor.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^N' edit-command-line
bindkey -M vicmd '^N' edit-command-line

# Ensure no noticable delay when switching from insert to normal mode.
KEYTIMEOUT=1

# Prepare for building prompts that dynamically update based on input state.
inactive_mode_label="%K{#444444}   %k"
normal_mode_label="%K{#CCCCCC} %F{#222222}N%f %k"
insert_mode_label="%K{#44CC44} %F{#222222}I%f %k"
visual_mode_label="%K{#44CCCC} %F{#222222}V%f %k"
mode_label="$inactive_mode_label"
prompt_prefix="%B"
prompt_suffix="%b "
prompt_content="%F{#00FF00}%n%f@%F{#FF00FF}%m%f %F{#00FFFF}%~%f"
prompt_focus="%K{#444444} $prompt_content%k%F{#444444}%f"
prompt_unfocus="%K{#222222} $prompt_content%k%F{#222222}%f"
prompt_scrollback="%K{#222222}$prompt_content%k%F{#222222}%f"

# If there is no window id, the shell is probably running in a tty. This
# environment doesn't have full rgb color or unicode support, hence requiring a
# prompt without those properties.
if [[ "$WINDOWID" == "" ]]; then
  inactive_mode_label="%b%F{white}[ ]%f %B"
  normal_mode_label="%F{white}[N]%f "
  insert_mode_label="%F{green}[I]%f "
  visual_mode_label="%F{cyan}[V]%f "
  mode_label="$inactive_mode_label"
  prompt_prefix="%B"
  prompt_suffix="$%b "
  prompt_content="%F{green}%n%f@%F{magenta}%m%f %F{cyan}%~%f"
  prompt_focus="$prompt_content"
  prompt_unfocus="$prompt_content"
  prompt_scrollback="$prompt_content"
fi

# Update prompt's mode label and the cursor color when the mode switches or a
# line is initialized.
function update_prompt_mode() {
  old_label="$mode_label"
  if [[ "$KEYMAP" == "vicmd" ]]; then
    if [[ "$REGION_ACTIVE" -ne 0 ]]; then
      mode_label="$visual_mode_label"
      echo -ne "\e]12;#44CCCC\a"
    else
      mode_label="$normal_mode_label"
      echo -ne "\e]12;#CCCCCC\a"
    fi
  else
    mode_label="$insert_mode_label"
    echo -ne "\e]12;#44CC44\a"
  fi
  if [[ "$mode_label" != "$old_label" ]]; then
    PROMPT="$prompt_prefix$mode_label$prompt_focus$prompt_suffix"
    zle reset-prompt
  fi
}
zle -N zle-line-pre-redraw update_prompt_mode
zle -N zle-line-init update_prompt_mode
zle_highlight=(region:bg=#113366)

# Remove prompt's mode label before it's sent to the scrollback buffer.
function remove_prompt_mode() {
  PROMPT="$prompt_prefix$prompt_scrollback$prompt_suffix"
  zle reset-prompt
  # Guarantee that the mode label changes during the next prompt update.
  mode_label=""
}
zle -N zle-line-finish remove_prompt_mode

# Apply different prompt highlights when the shell window is or isn't focused.
function enable_focus_reporting() {
  printf "\e[?1004h"
}
enable_focus_reporting
function focus_gained() {
  mode_label=""
  update_prompt_mode
}
function focus_lost() {
  PROMPT="$prompt_prefix$inactive_mode_label$prompt_unfocus$prompt_suffix"
  zle reset-prompt
}
zle -N focus_gained
zle -N focus_lost
bindkey "\e[I" focus_gained
bindkey "\e[O" focus_lost
bindkey -M vicmd "\e[I" focus_gained
bindkey -M vicmd "\e[O" focus_lost

# Motion keys only perfrom motions and up motion doesn't jump to the start of
# the first line.
function up_line() {
  if [[ "$LBUFFER" == *$'\n'* ]]; then
    zle up-line
  fi
}
zle -N up_line
bindkey -M vicmd "k" up_line
bindkey -M vicmd "j" down-line

# Arrow keys only cycle through history.
bindkey "\x1b[A" up-history
bindkey "\x1b[B" down-history
bindkey -M vicmd "\x1b[A" up-history
bindkey -M vicmd "\x1b[B" down-history

# Use shift+enter to add new lines.
function new_line() {
  LBUFFER+=$'\n'
}
zle -N new_line
bindkey '\x1b[13;2u' new_line
bindkey -M vicmd '\x1b[13;2u' vi-open-line-below

# Press ctrl-backspace to delete a word.
bindkey '^H' backward-delete-word

# Pressing backspace will always delete the previous character.
bindkey '^?' backward-delete-char

# Copy to clipboard when there's a visual selection.
function copy_to_clipboard() {
  if [[ "$REGION_ACTIVE" -ne 0 ]]; then
    zle copy-region-as-kill
    echo -n "$CUTBUFFER" | xclip -selection clipboard -in
    zle deactivate-region
  fi
}
zle -N copy_to_clipboard
bindkey -M visual "^C" copy_to_clipboard
bindkey -M main "^C" undefined-key
# Guaratee that ctrl+c sends an interrupt if a command is executing.
function zle-pre-cmd {
  stty intr "^@"
}
function zle-pre-exec {
  stty intr "^C"
}
precmd_functions=(${precmd_functions[@]} "zle-pre-cmd")
preexec_functions=(${preexec_functions[@]} "zle-pre-exec")

# Ensure a somewhat persistent shell history.
HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt inc_append_history
setopt hist_ignore_dups

nv() {
  command nvim "$@"
  enable_focus_reporting
}

source <(fzf --zsh)
eval "$(zoxide init zsh)"

