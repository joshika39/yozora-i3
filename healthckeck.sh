#!/bin/bash
# This script is used to check the health of the i3 setup

if ! [ -f $HOME/.config/i3/install.sh ]; then
    echo "unhealthy"
    exit 1
fi

