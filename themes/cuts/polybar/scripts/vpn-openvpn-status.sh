#!/bin/sh

printf "VPN " && (nmcli | grep VPN | head -n 1 | awk '{print "connected at " $1}' | cut -d '.' -f 1 && echo is down) | head -n 1
