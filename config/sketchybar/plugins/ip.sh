#!/bin/bash

IFACE=en0

sketchybar --set $NAME label="$(ip -4 addr show $IFACE | grep inet | awk '{print $2}' | cut -d'/' -f1)"

