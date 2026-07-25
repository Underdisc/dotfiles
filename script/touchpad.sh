#!/bin/sh
action=$1
device_name="ETPS/2 Elantech Touchpad"
enabled=$(xinput list-props "$device_name" | grep "Device Enabled" | awk '{print $4}')

enabled_icon="󰭯"
disabled_icon="󰌌"
icon="$disabled_icon"
if [ "$enabled" = "1" ]; then
  icon="$enabled_icon"
fi

if [ "$action" = "toggle" ]; then
  if [ "$enabled" = "1" ]; then
    xinput disable "$device_name"
    icon="$disabled_icon"
  else
    xinput enable "$device_name"
    icon="$enabled_icon"
  fi
fi

echo "$icon"

