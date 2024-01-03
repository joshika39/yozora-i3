#!/usr/bin/bash

mapfile -t displays < <(xrandr | grep ' connected')

for (( i=0; i<${#displays[@]}; i++)); do

  	name=`echo ${displays[i]} | cut -d " " -f 1`
	echo $name
	file=$HOME/.i3/workspace-$name-$1.json
	if [[ -f $file ]]; then
		echo $file
		i3-msg "append_layout $file"	
	fi
done


