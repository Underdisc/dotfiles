#!/bin/bash
action="$1"
icons=("󰖚" "󰖙")
temperatures=("2900K" "6500K")

icon=""
temperature=$(cat ~/.config/polybar/redshift.txt)

# Set the icon for the current temperature and the temperature if the saved
# value isn't valid.
if [[ "$action" == "init" ]]; then
  if [[ "$temperature" == "${temperatures[1]}" ]]; then
    icon="${icons[1]}"
  elif [[ "$temperature" == "${temperatures[0]}" ]]; then
    icon="${icons[0]}"
  else
    icon="${icons[1]}"
    temperature="${temperatures[1]}"
  fi
fi

# Toggle between temperatures.
if [[ "$action" == "toggle" ]]; then
  if [[ "$temperature" == "${temperatures[0]}" ]]; then
    icon="${icons[1]}"
    temperature="${temperatures[1]}"
  elif [[ "$temperature" == "${temperatures[1]}" ]]; then
    icon="${icons[0]}"
    temperature="${temperatures[0]}"
  fi
fi

# Set the new temperature.
echo "$temperature" > ~/.config/polybar/redshift.txt
redshift -P -O "$temperature"
echo "$icon"

