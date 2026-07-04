#!/bin/sh
hostname=$(hostname)
if [[ $hostname =~ breakout ]]; then
  source .config/xorg/breakout.sh
elif [[ $hostname =~ octane ]]; then
  source .config/xorg/octane.sh
fi

# Make the save file dialog appear on request within firefox.
GTK_USE_PORTAL=1
dbus-update-activation-environment \
  --systemd DISPLAY I3SOCK XAUTHORITY GTK_USE_PORTAL

# Enable drive automounting.
udiskie --automount --no-notify &

# Set the screen saver settings.
xset dpms 0 0 900
xset -dpms
xset s off

unclutter --timeout 5 -jitter 5 &
xrdb <<< "Xcursor.size: 16"

exec i3
