#!/bin/sh

printf "  vpn " && (nmcli | grep VPN | head -n 1 | awk '{print "on"}' | cut -d '.' -f 1 && echo off) | head -n 1
