#!/bin/bash

DIR="$HOME/Pictures/screenshots/"
NAME="screenshot_$(date +%d%m%Y_%H%M%S).png"

option2="Selected area"
option3="Fullscreen (delay 1 sec)"

options="$option2\n$option3"

if [ ! $1 ]; then
    choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/git/my_configs/rofi/config-screenshot.rasi -i -no-show-icons -l 2 -width 30 -p "Take Screenshot")
    case $choice in
      $option2)
        grim -g "$(slurp)" - | swappy -f -
        notify-send "Screenshot created" "Mode: Selected area"
      ;;
      $option3)
        sleep 1
        grim - | swappy -f -
        notify-send "Screenshot created" "Mode: Fullscreen"
      ;;
    esac
else
    case $1 in
      "select")
        grim -g "$(slurp)" - | swappy -f -
        notify-send "Screenshot created" "Mode: Selected area"
      ;;
      "full")
        sleep 1
        grim - | swappy -f -
        notify-send "Screenshot created" "Mode: Fullscreen"
      ;;
      *)
        echo "Invalid option"
      ;;
    esac
fi

