#!/usr/bin/env bash

local style=$POLYBAR_STYLE

# arguments supplied
if [ $# -ne 0 ]
then
    style=$1
fi

rofi -no-config -no-lazy-grab -show drun -modi drun -theme ~/.config/polybar/$style/rofi/launcher.rasi
