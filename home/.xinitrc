#!/bin/sh
xrandr \
  --output DP-0    --auto --rotate normal --pos 0x683 --primary \
  --output DVI-D-0 --auto --rotate left   --pos 1920x0
xset r rate 370 30
unclutter --timeout 3 -jitter 5 &
exec i3
