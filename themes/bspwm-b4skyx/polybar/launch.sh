#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Get network Interface
network_interface=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

## Load bar on primary monitor
DEFAULT_NETWORK_INTERFACE=$network_interface polybar -c ~/.config/polybar/config.ini main &

# Load on second monitor if connected
external_monitor=$(xrandr --query | grep 'HDMI-2')
if [[ $external_monitor = HDMI-2\ connected* ]]; then
	polybar -c ~/.config/polybar/config.ini secondary &
fi
