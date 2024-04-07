#!/bin/bash

# This script is used to connect to a remote desktop server with a rofi menu wich lists all the available servers.
# Then it uses xfreerdp to connect to the selected server. And prompts for the password and username.

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

start() {
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

  size=$(echo -e "800x600\n1024x768\n1280x720\n1280x800\n1366x768\n1440x900\n1600x900\n1920x1080\n2560x1440" | tac | rofi -dmenu -p "Select resolution")
  if [ -z "$size" ]; then
      dunstify "RDP Connect" -u critical "No resolution selected" --timeout 500 --icon=dialog-error
      exit 1
  fi

  xfreerdp /size:$size /p:$password /u:$username +clipboard /sound:sys:pulse /v:$selected_server
}

# List the running rdp connections and prompt to select one to disconnect or all of them

disconnect(){
  connections=$(ps aux | grep -E 'xfreerdp' | grep -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | awk '{gsub("/v:","",$17); print "pid:", $2 ", ip:", $17}')
  if [ -z "$connections" ]; then
      dunstify "RDP Connect" -u critical "No connections found" --timeout 500 --icon=dialog-error
      exit 1
  fi

  selected_connection=$(input_menu "Select a connection to disconnect" "$connections")
  if [ $? -ne 0 ]; then
      dunstify "RDP Connect" -u critical "No connection selected" --timeout 500 --icon=dialog-error
      exit 1
  fi
  pid=$(echo $selected_connection | awk '{gsub("pid:",""); gsub(",",""); print $1}')
  echo "Killing process $pid"
  kill -9 $pid
}

if [ "$1" == "disconnect" ]; then
  disconnect
fi

if [ "$1" == "start" ]; then
  start
fi


