#!/bin/bash

time=$(date +"%Y_%m_%d_%H:%M")

folder=$HOME/Pictures/Screenshots

image=$folder/$time-screenshot.png

[[ ! -d $folder ]] && mkdir -p $folder

	selected=$(echo "Full
Rectangle
Program" | rofi -dmenu -p "Select Screenshot Type")

[[ -z $selected ]] && exit

if [[ $selected == "Full" ]];then 
	sleep 1
	import -silent -window root $image
fi

if [[ $selected == "Rectangle" ]];then 
	sleep 1
	import $image
fi

if [[ $selected == "Program" ]];then 
	import $image
fi

if [[ -f $image ]]; then
	echo "screenshot success"
else
	exit
fi

# echo "Copy manually:"
# echo "xclip -selection clipboard -t image/png < $image" 

xclip -selection clipboard -t image/png < $image
