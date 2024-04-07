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
      echo "No value entered. Exiting..." > /dev/tty
      exit 1
    fi
    echo "$entered_value"
    return 0
  fi

  entered_value=$(echo "$options" | rofi -dmenu -p "$prompt")
  if [ -z "$entered_value" ]; then
    echo "No value entered. Exiting..." > /dev/tty
    exit 1
  fi
  echo "$entered_value"
  return 0
}

if [ ! -x "$(command -v dunst)" ]; then
    echo "Dunst is not installed. Please install dunst."
    exit 1
fi


if [ ! -x "$(command -v rofi)" ]; then
    dunstify "RDP Connect" -u critical "Rofi is not installed. Please install rofi." --timeout 500 --icon=dialog-error
    exit 1
fi

if [ ! -x "$(command -v xfreerdp)" ]; then
    dunstify "RDP Connect" -u critical "FreeRDP is not installed. Please install freerdp." --timeout 500 --icon=dialog-error
    exit 1
fi

servers=$(tailscale status | grep windows | awk '{print $1}')

if [ -z "$servers" ]; then
    dunstify "RDP Connect" -u critical "No servers found" --timeout 500 --icon=dialog-error
    exit 1
fi


selected_server=$(input_menu "Select a server" "$servers")
if [ $? -ne 0 ]; then
    dunstify "RDP Connect" -u critical "No server selected" --timeout 500 --icon=dialog-error
    exit 1
fi
username=$(input_menu "Enter username")
if [ $? -ne 0 ]; then
    dunstify "RDP Connect" -u critical "No username entered" --timeout 500 --icon=dialog-error
    exit 1
fi
password=$(rofi -dmenu -p "Enter password" -password)
if [ $? -ne 0 ]; then
    dunstify "RDP Connect" -u critical "No password entered" --timeout 500 --icon=dialog-error
    exit 1
fi

echo "Running freerdp /v:$selected_server /u:$username /p:$password" +clipboard /sound:sys:pulse
freerdp-shadow-cli3 /v:$selected_server /u:$username /p:$password

