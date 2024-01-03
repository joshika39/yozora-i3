#!/bin/bash

mapfile -t displays < <(xrandr | grep ' connected')


crops=()

for (( i=0; i<${#displays[@]}; i++)); do
#	echo $i
  	name=`echo ${displays[i]} | cut -d " " -f 1`


	if [[ `echo ${displays[i]} | cut -d " " -f 3` == "primary" ]]; then
		crop="`echo ${displays[i]} | cut -d " " -f 4`"
	else
		crop="`echo ${displays[i]} | cut -d " " -f 3`"
	fi
  
	import -window root -crop $crop /tmp/image$i.png
done


