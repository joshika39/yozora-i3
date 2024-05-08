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

is_running=$(tailscale status | grep -q "Tailscale is stopped"; echo $?)

if [ "$is_running" -eq 0 ]; then
    selected=$(echo -e "Start\nQuit" | rofi -dmenu -p "Tailscale is not running")
else
    selected=$(echo -e "Stop\nRestart\nSelect Exit Node\nReset\nQuit" | rofi -dmenu -p "Tailscale is running")
fi

if [ "$selected" == "Quit" ]; then
    exit
fi

if [ "$selected" == "Start" ]; then
    sudo tailscale up
    exit
fi

if [ "$selected" == "Stop" ]; then
    sudo tailscale down
    exit
fi

if [ "$selected" == "Restart" ]; then
    sudo tailscale down
    sudo tailscale up
    exit
fi

if [ "$selected" == "Select Exit Node" ]; then
    # Show the list of exit nodes with the "<ip> - <hostname>" format
    # The exit nodes are the ones with the "exit node" in the line
    # Show in a rofi menu
    selected=$(tailscale status | grep "exit node" | awk '{print $1" - "$2}' | rofi -dmenu -p "Select Exit Node")

    if [ -z "$selected" ]; then
        exit
    fi

    selected_ip=$(echo $selected | awk -F' - ' '{print $1}')
    selected_hostname=$(echo $selected | awk -F' - ' '{print $2}')
    my_hostname=$(hostname)
    use_lan=$(echo -e "Yes\nNo" | rofi -dmenu -p "Use LAN IP for $selected_hostname?")
    lan_command=""

    if [ "$use_lan" == "Yes" ]; then
        lan_command=" --exit-node-allow-lan-access=true"
    fi

    if [ "$selected" != "$selected_hostname" ]; then
        sudo tailscale up --exit-node=$selected_ip$lan_command
    fi
    exit
fi

if [ "$selected" == "Reset" ]; then
    sudo tailscale up --reset
    exit
fi



