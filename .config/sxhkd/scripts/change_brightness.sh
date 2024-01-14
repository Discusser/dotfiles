#!/bin/bash

if [ $# -eq 0 ]
then
  echo "No arguments supplied, expected a signed number"
  exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

backlight_path="/sys/class/backlight"
card=$(ls $backlight_path | head -1)
card_path="$backlight_path/$card"

max_brightness=$(cat "$card_path/max_brightness")
brightness_path="$card_path/brightness"
current_brightness=$(cat $brightness_path)
new_brightness=$((current_brightness * 100 / max_brightness + $1))

if [ $new_brightness -lt 10 ] && [ $1 -lt 0 ]
then
  echo "Brightness too low (< 10%), exiting"
  exit 2
fi

new_brightness=$((new_brightness * max_brightness / 100))
new_brightness=$((new_brightness > max_brightness ? max_brightness : new_brightness))

echo $new_brightness > $brightness_path

id_to_replace=0
id_path="$SCRIPT_DIR/brightness_notification_id" 
if [ -s $id_path ]
then
  id_to_replace=$(cat $id_path)
else
  echo 0 > $id_path
fi

echo $id_to_replace
echo $id_path

notify-send --urgency="low" --replace-id=$id_to_replace --print-id "Brightness" "Brightness is now set to $((new_brightness * 100 / max_brightness))%" > $id_path
