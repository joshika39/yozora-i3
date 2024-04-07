#!/bin/bash

# This script is used to connect to a remote desktop server with a rofi menu wich lists all the available servers.
# Then it uses xfreerdp to connect to the selected server. And prompts for the password and username.


# List of servers
# Check if tailscale is installed

input_menu() {
  local prompt=$1
  local options=$2

  if [[ -z "$options" ]]; then
    entered_value=$(rofi -dmenu -p "$prompt")
    if [ -z "$entered_value" ]; then
      echo "No value entered. Exiting..."
      exit 1
    fi
    echo "$entered_value"
    return 0
  fi

  entered_value=$(echo "$options" | rofi -dmenu -p "$prompt")
  if [ -z "$entered_value" ]; then
    echo "No value entered. Exiting..."
    exit 1
  fi
  echo "$entered_value"
  return 0
}

if [ -x "$(command -v tailscale)" ]; then
    servers=$(tailscale status | grep -Eo 'rdp://[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
else
    servers=$(cat ~/.config/rdp-servers)
fi

# Check if rofi is installed
if [ ! -x "$(command -v rofi)" ]; then
    echo "Rofi is not installed. Please install rofi."
    exit 1
fi

# Check if xfreerdp is installed
if [ ! -x "$(command -v xfreerdp)" ]; then
    echo "xfreerdp is not installed. Please install xfreerdp."
    exit 1
fi

selected_server=$(input_menu "Select a server" "$servers")
username=$(input_menu "Enter username")
password=$(rofi -dmenu -p "Enter password" -password)

xfreerdp /v:$selected_server /u:$username /p:$password

