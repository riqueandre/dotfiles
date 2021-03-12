#!/usr/bin/env bash

ACTIVE_STYLE=$POLYBAR_STYLE
# arguments supplied
if [ $# -ne 0 ]
then
    ACTIVE_STYLE=$1
fi
rofi -no-config -no-lazy-grab -show drun -modi drun -theme ~/.config/polybar/$ACTIVE_STYLE/rofi/launcher.rasi
