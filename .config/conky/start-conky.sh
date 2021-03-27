#!/bin/bash
killall -q conky
conky -c $HOME/.config/conky/conky.conf &
