source ".config/shrc/local.sh"

hostname=$(hostname)
if [[ $hostname =~ breakout ]]; then
  export MOZ_USE_XINPUT2=1
fi

export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export PAGER="less"
export GTK_THEME=Adwaita:dark

