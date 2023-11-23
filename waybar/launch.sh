#!/bin/sh

killall waybar
sleep 0.2
themestyle="/ml4w;/ml4w/light"

if [ -f ~/.cache/.themestyle.sh ]; then
    themestyle=$(cat ~/.cache/.themestyle.sh)
else
    touch ~/.cache/.themestyle.sh
    echo "$themestyle" > ~/.cache/.themestyle.sh
fi

IFS=';' read -ra arrThemes <<< "$themestyle"
echo ${arrThemes[0]}

if [ ! -f ~/git/my_configs/waybar/themes${arrThemes[1]}/style.css ]; then
    themestyle="/ml4w;/ml4w/light"
fi

waybar -c ~/git/my_configs/waybar/themes${arrThemes[0]}/config -s ~/git/my_configs/waybar/themes${arrThemes[1]}/style.css &
