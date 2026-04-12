#!/bin/sh

# Make the save file dialog appear on request within firefox.
GTK_USE_PORTAL=1
dbus-update-activation-environment \
  --systemd DISPLAY I3SOCK XAUTHORITY GTK_USE_PORTAL

# Enable drive automounting.
udiskie --automount --no-notify &

nvidia-settings --assign CurrentMetaMode="
DPY-2: nvidia-auto-select {
  ForceFullCompositionPipeline=On
},
DPY-0: nvidia-auto-select {
  ForceFullCompositionPipeline=On
}"
xrandr \
  --output DP-0    --mode 1920x1080 --rate 100 --rotate normal --pos 0x683 --primary \
  --output DVI-D-0 --mode 1920x1080 --rate 60  --rotate left   --pos 1920x0

xset r rate 370 30
unclutter --timeout 5 -jitter 5 &
xrdb <<< "Xcursor.size: 16"

xmodmap "$XMODMAP_CONFIG"

exec i3
