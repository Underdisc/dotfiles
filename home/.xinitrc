#!/bin/sh

# Make the save file dialog appear on request within firefox.
GTK_USE_PORTAL=1
dbus-update-activation-environment \
  --systemd DISPLAY I3SOCK XAUTHORITY GTK_USE_PORTAL

# Enable drive automounting.
udiskie --automount --no-notify &

xrandr \
  --output DP-0    --auto --rotate normal --pos 0x683 --primary \
  --output DVI-D-0 --auto --rotate left   --pos 1920x0
xset r rate 370 30
unclutter --timeout 3 -jitter 5 &
xrdb <<< "Xcursor.size: 16"

xmodmap "$XMODMAP_CONFIG"

exec i3
