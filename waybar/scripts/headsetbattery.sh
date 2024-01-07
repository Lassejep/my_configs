#!/bin/sh

battery_level=$(headsetcontrol -b | grep Battery | cut -d' ' -f2)

css_class="green"
icon=" "

if [ "$battery_level" == "Charging" ]; then
    css_class="green"
    icon=" "
fi

if [ "$battery_level" == "100%" ]; then
    css_class="green"
    icon=" "
fi

if [ "$battery_level" == "75%" ]; then
    css_class="green"
    icon=" "
fi

if [ "$battery_level" == "50%" ]; then
    css_class="yellow"
    icon=" "
fi

if [ "$battery_level" == "25%" ]; then
    css_class="red"
    icon=" "
fi

printf '{"text": "%s", "alt": "%s", "tooltip": "Battery: %s", "class": "%s"}' "$battery_level" "$icon" "$battery_level" "$css_class"
