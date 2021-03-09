#!/bin/sh

printf "VPN: " && (nmcli | grep VPN | head -n 1 | awk '{print $1}' | cut -d '.' -f 1 && echo down) | head -n 1
