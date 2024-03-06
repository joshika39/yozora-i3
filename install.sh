#!/usr/bin/env bash

# Install the required packages

if ! [ -f ~/.config/yozora ]; then
  git clone https://github.com/joshika39/yozora.git ~/.config/yozora
fi

bash ~/.config/yozora/install.sh
