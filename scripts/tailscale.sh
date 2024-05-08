#!/bin/bash

# Tailscale management options with rofi

# Usage: tailscale.sh [--select-exitnode] [--reset] [--down]


# If tailscale is not installed, exit

if ! command -v tailscale &> /dev/null
then
    echo "tailscale could not be found"
    exit
fi

# If script is ran without any arguments, show the main menu
# Main menu options: Start: if not running; Stop, Restart, Select Exit Node, Reset: if running

# Use Rofi to show the menu

# is_running is false when the output of tailscale status is not "Tailscale is stopped"
is_running=$(tailscale status | grep -q "Tailscale is stopped"; echo $?)

echo "is_running: $is_running"

