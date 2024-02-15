#!/bin/sh

# Exit if .env not exists
[ -f "$HOME/.config/i3/.env" ] || exit 1

# Load .env
source "$HOME/.config/i3/.env"

# Check if the ACCESS_KEY is set
[ -z "$ACCESS_KEY" ] && echo "ACCESS_KEY is not set" && exit 1

# Get a random image from the unsplash api use the $ACCESS_KEY

url="https://api.unsplash.com/photos/random?client_id=${ACCESS_KEY}&collections=11445541&orientation=landscape"

# Get the image fron a GET endpoint
image_url=$(curl $url | jq -r '.urls.full')
image_path="$HOME/.config/i3/background.jpg"

[ -z "$image_url" ] && echo "Image url is empty" && exit 1


# Download the image
curl -o $image_path $image_url

# Get the connected monitor names

monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)

# Set the background image for each monitors

for monitor in $monitors; do
    feh --bg-fill --no-xinerama $image_path --bg-fill --no-xinerama $image_path --bg-fill --no-xinerama $image_path
done

