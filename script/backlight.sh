#!/bin/bash
action="$1"

if [[ "$action" == "toggle" ]]; then
  current=$(brightnessctl get)
  if [ "$current" -lt 350 ]; then
    brightnessctl set 705 > /dev/null
  else
    brightnessctl set 50 > /dev/null
  fi
elif [[ "$action" == "up" ]]; then
  brightnessctl --min-value=30 -e set +5% > /dev/null
elif [[ "$action" == "down" ]]; then
  brightnessctl --min-value=30 -e set 5%- > /dev/null
fi

current="$(brightnessctl get)"
max=$(brightnessctl max)
percent=$(( (current * 100) / max ))
echo "󰱌 $percent%"
