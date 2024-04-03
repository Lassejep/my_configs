#!/bin/sh

battery_level=$(headsetcontrol -b | grep Level | cut -d' ' -f2)
battery_status=$(headsetcontrol -b | grep Status | cut -d' ' -f2)

if [ "$battery_status" == "BATTERY_CHARGING" ]; then
    css_class="green"
    icon=" "

elif [ "$battery_status" == "BATTERY_UNAVAILABLE" ]; then
    css_class="green"
    icon=" "
    battery_level="N/A"

elif [ "$battery_level" == "100%" ]; then
    css_class="green"
    icon=" "

elif [ "$battery_level" == "75%" ]; then
    css_class="green"
    icon=" "

elif [ "$battery_level" == "50%" ]; then
    css_class="yellow"
    icon=" "

elif [ "$battery_level" == "25%" ]; then
    css_class="red"
    icon=" "

else 
    css_class="red"
    icon=" "
fi

printf '{"text": "%s", "alt": "%s", "tooltip": "Battery: %s", "class": "%s"}' "$battery_level" "$icon" "$battery_level" "$css_class"
