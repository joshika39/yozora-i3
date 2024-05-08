#!/bin/bash

# Tailscale management options with rofi

# Usage: tailscale.sh [--select-exitnode] [--reset] [--down]


# If tailscale is not installed, exit

if ! command -v tailscale &> /dev/null
then
    echo "tailscale could not be found"
    exit
fi

