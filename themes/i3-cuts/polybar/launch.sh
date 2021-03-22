#!/usr/bin/env bash

dir="$HOME/.config/polybar"
themes=(`ls --hide="launch.sh" $dir`)

launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# default interface with route
	iface_default=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

	IFACE_DEFAULT=$iface_default polybar -q top -c "$dir/cuts/config.ini" &
	IFACE_DEFAULT=$iface_default polybar -q bottom -c "$dir/cuts/config.ini" &
}

launch_bar
