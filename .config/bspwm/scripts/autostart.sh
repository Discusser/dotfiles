#!/bin/bash

function run {
  killall -q $1
  $@ &
}

setxkbmap -option compose:ralt

feh --no-fehbg --bg-fill $HOME/Pictures/Wallpapers/sve.png

# Startup processes
# Picom can apply changes when saving config file, no need to restart each time, doing the following is fine because picom exits if another instance is already open
picom --experimental-backends &

run sxhkd &
run polybar 2>/tmp/polybar.log &
run dunst &
