#!/usr/bin/env bash


monitor1=$MONITOR1
monitor2=$MONITOR2

reachedSecond=0
resCount=0
RESOLUTIONS=()
loc=$HOME/.2ndres
[[ -f $loc ]] && rm $loc
touch $loc
xrandr | while read -r line ; do
	
	if  [[ $line == *"$MONITOR2"* ]] ;then 
		reachedSecond=1
	fi

	if (( $reachedSecond == 1 )); then

		if (( resCount < 8 )); then
			test="`echo $line grep -E \'[0-9]{3,}x[0-9]{3,}\' | awk '{print $1}'`"
			echo "$test" >> $loc
			
			(( resCount++ ))
		fi
	fi	
done

res=()

while read line
do
#	echo $line
	res+=( "$line" )
done < $HOME/.2ndres

	selected=$(echo "Laptop Only
HDMI Only
Dual Monitor
Duplicate" | rofi -dmenu -p "Select Monitor Setup ")
	
[[ -z $selected ]] && exit

	if [ "$selected" == "Laptop Only" ]; then
		xrandr --output "$monitor2" --off
		exit
	fi

	if [ "$selected" == "HDMI Only" ]; then
		mode=$(cat $HOME/.2ndres | rofi -dmenu -p "Select Resolution")
		xrandr --output "$monitor1" --off
		xrandr --output "$monitor2" --mode $mode
		exit
	fi

	if [ "$selected" == "Dual Monitor" ]; then
		position=$(echo "left-of
right-of" | rofi -dmenu -p "Select Monitor position")
		mode=$(cat $HOME/.2ndres | rofi -dmenu -p "Select Resolution")
		xrandr --output "$monitor2" --mode $mode --$position "$monitor1"
	fi
	if [ "$selected" == "Duplicate" ];then
		xrandr --output "$monitor2" --mode 1920x1080 --same-as $monitor1
	fi
#fi

source $HOME/.config/xinit.d/00-detect-setup.sh

source $HOME/.config/xinit.d/10-update-i3.sh

feh --no-fehbg --bg-fill "$HOME/.BG.jpg"

$HOME/.config/polybar/launch.sh

i3-msg reload
