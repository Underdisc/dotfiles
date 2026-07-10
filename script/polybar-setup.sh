#!/bin/bash
hostname=$(hostname)
if [[ $hostname =~ breakout ]]; then
  polybar breakout_primary &
elif [[ $hostname =~ octane ]]; then
  polybar octane_primary &
  polybar octane_secondary &
fi
