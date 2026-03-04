#!/bin/bash
action="$1"

states=("night" "day")
icons=("" "󰖙")
temperatures=("2900K" "6500K")
backlights=("0" "75")

state="$(cat ~/.config/polybar/nightshift.txt)"

# Set either an initial state or swap between states.
if [[ "$action" == "init" ]]; then
  if [[ "$state" != "${states[0]}" && "$state" != "${states[1]}" ]]; then
    state=${states[0]}
  fi
fi
if [[ "$action" == "toggle" ]]; then
  if [[ "$state" == "${states[0]}" ]]; then
    state="${states[1]}"
  elif [[ "$state" == "${states[1]}" ]]; then
    state="${states[0]}"
  fi
fi

# Set variables for the current state.
state_index=""
if [[ "$state" == "${states[0]}" ]]; then
  state_index=0
elif [[ "$state" == "${states[1]}" ]]; then
  state_index=1
fi
icon="${icons[$state_index]}"
temperature="${temperatures[$state_index]}"
backlight="${backlights[$state_index]}"

set_backlight_value() {
  local ddcutil_flags="--skip-ddc-checks -d"
  local monitor="$1"
  local backlight="$2"
  ddcutil $ddcutil_flags $monitor setvcp 10 "$backlight"
}

# Apply day or night settings.
echo "$state" > ~/.config/polybar/nightshift.txt
redshift -P -O "$temperature"
set_backlight_value 1 "$backlight"
set_backlight_value 2 "$backlight"
echo "$icon"
