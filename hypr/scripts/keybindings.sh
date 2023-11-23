#!/bin/bash

config_file=~/git/my_configs/hypr/conf/keybindings.conf
keybinds=$(grep -oP '(?<=bind = ).*' $config_file)
keybinds=$(echo "$keybinds" | sed 's/$mainMod/SUPER/g'|  sed 's/,\([^,]*\)$/ = \1/' | sed 's/, exec//g' | sed 's/^,//g')

rofi -dmenu -replace -p "Keybinds" -config ~/git/my_configs/rofi/config-compact.rasi <<< "$keybinds"
