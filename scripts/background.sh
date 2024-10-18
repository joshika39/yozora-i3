#!/usr/bin/env bash

image_path="$HOME/.background.jpg"

if [ -z $SKIP_BACKGROUND ]; then
  echo "getting new image"
  echo "testtest $SKIP_BACKGROUND" >$HOME/test-tmp.txt
  exit 0
  [ -f "$HOME/.config/i3/.env" ] || exit 1
  source "$HOME/.config/i3/.env"
  [ -z "$ACCESS_KEY" ] && echo "ACCESS_KEY is not set" && exit 1
  url="https://api.unsplash.com/photos/random?client_id=${ACCESS_KEY}&collections=11445541&orientation=landscape"
  image_url=$(curl $url | jq -r '.urls.full')

  [ -z "$image_url" ] && echo "Image url is empty" && exit 1
  curl -o $image_path $image_url
else
  echo "skipping background"
fi

echo "using image $image_path"
monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)
echo "monitors: $monitors"
for monitor in $monitors; do
  feh --bg-fill --no-xinerama $image_path --bg-fill --no-xinerama $image_path --bg-fill --no-xinerama $image_path
done
