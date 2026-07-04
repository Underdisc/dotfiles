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

