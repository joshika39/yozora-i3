#!/bin/bash


# This script is used to select the primary display for the system with rofi menu

# Get the list of connected displays
displays=$(xrandr | grep " connected" | awk '{print $1}')

# Create the list of display names
display_names=$(for display in $displays; do
    echo $display
done)

# Use rofi to display the list of displays

selected_display=$(echo "$display_names" | rofi -dmenu -p "Select primary display")

# Set the primary display

xrandr --output $selected_display --primary
