#!/bin/bash

monitor="$1"
action="$2"
ddcutil_flags="--skip-ddc-checks -d $monitor"
vcp_code=10

get_backlight_value() {
  local output=$(ddcutil $ddcutil_flags getvcp "$vcp_code")
  local sed_expression="s/.*current value = \s*\([0-9]\+\).*/\1/p"
  local value=$(echo "$output" | sed -n "$sed_expression")
  echo "$value"
}

set_backlight_value() {
  local value="$2"
  ddcutil $ddcutil_flags setvcp "$vcp_code" "$value"
}

clamp_backlight_value() {
  local value="$value"
  if (( value > 100 )); then
    value=100
  elif (( value < 0 )); then
    value=0
  fi
  echo "$value"
}

value=$(get_backlight_value "$monitor")
if [[ "$action" == "up" ]]; then
  value=$(( value + 25 ))
fi
if [[ "$action" == "down" ]]; then
  value=$(( value - 25 ))
fi
value=$(clamp_backlight_value)
set_backlight_value "$monitor" "$value"
echo "󰱌 $value"
