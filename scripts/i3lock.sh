#!/usr/bin/env bash

mapfile -t res < <(xrandr | grep '*' | awk '{print $1}')


for (( i=0; i < ${#res[@]}; i++ )); 
do
	if (( i == 0 )); then
		res1=${res[i]}
	else
		res2=${res[i]}
	fi
done

## Get colors -----------------

FG=`xrdb -query | grep -w "*foreground" | cut -f 2`
BG=`xrdb -query | grep -w "*background" | cut -f 2`

FG_alt=`xrdb -query | grep -w "*foreground_alt" | cut -f 2`
BG_alt=`xrdb -query | grep -w "*background_alt" | cut -f 2`

a1=`xrdb -query | grep -w "*accent1" | cut -f 2`
a2=`xrdb -query | grep -w "*accent2" | cut -f 2`
a3=`xrdb -query | grep -w "*accent3" | cut -f 2`
a4=`xrdb -query | grep -w "*accent4" | cut -f 2`
a5=`xrdb -query | grep -w "*accent5" | cut -f 2`
a6=`xrdb -query | grep -w "*accent6" | cut -f 2`
a7=`xrdb -query | grep -w "*accent7" | cut -f 2`

alert=`xrdb -query | grep -w "*alert" | cut -f 2`
warning=`xrdb -query | grep -w "*warning" | cut -f 2`
success=`xrdb -query | grep -w "*success" | cut -f 2`

lockimage=/tmp/lockimage.png

scrot $lockimage

mapfile -t displays < <(xrandr | grep ' connected')

for (( i=0; i<${#displays[@]}; i++)); do
#	echo $i
  	name=`echo ${displays[i]} | cut -d " " -f 1`


	if [[ `echo ${displays[i]} | cut -d " " -f 3` == "primary" ]]; then
		crop="`echo ${displays[i]} | cut -d " " -f 4`"
	else
		crop="`echo ${displays[i]} | cut -d " " -f 3`"
	fi
  
	import -silent -window root -crop $crop /tmp/image$i.png
done

images=()

for (( i=0; i < ${#displays[@]}; i++ ));
do
#	echo "${display[i]}
	images+=( "/tmp/image$i.png" )
done

text="fortune bible"
font="Cica-Regular"
BLUR="5x4"
hue=(-level "0%,100%,0.6" -set colorspace Gray -average) 
effect=(-scale 20% -scale 500% )

for (( i=0; i < ${#images[@]}; i++ ))
do
	convert ${images[i]} "${hue[@]}" "${effect[@]}" ${images[i]}
#	convert ${images[i]} -fill black -colorize 50% ${images[i]}
	convert ${images[i]} -fill $BG -colorize 100% ${images[i]}	

	if (( i == 0 )); then

		convert ${images[i]} -gravity center -repage $res1+0+0 -font "$font" -pointsize 26 -fill "$FG" -annotate +0+250 "`$text`" ${images[i]}

	else	
		 
		convert ${images[i]} -gravity center -repage $res2+0+0 -font "$font" -pointsize 26 -fill "$FG" -annotate +0+250 "`$text`" ${images[i]}

	fi
done


convert ${images[@]} +append $lockimage



i3lock \
-i $lockimage \
--color="${BG}" \
\
--insidever-color=${success}	\
--insidewrong-color=${warning}	\
--inside-color="${BG}00"	\
\
--ringver-color=${success} \
--ringwrong-color=${warning} \
--ring-color=${FG} \
\
--line-color=${a3} \
--separator-color=${a1}	\
\
--keyhl-color=${a7}	\
--bshl-color=${warning} \
\
--verif-color=${a5} \
--wrong-color=${FG} \
--layout-color=${FG} \
\
--time-color=${a3} \
--date-color=${a3} \
\
--pass-media-keys \
--pass-screen-keys \
--pass-power-keys \
--pass-volume-keys \
--{time,date,layout,verif,wrong}-font="Cica-Regular" \
--{time,date,layout,verif}-size=34 \
--{time,date,layout,verif,wrong}-align="centered" \
--wrong-size="24" \
--time-size=40 \
--date-size=24 \
--verif-text="検証" \
--wrong-text="間違ったパスワード" \
--noinput-text="空っぽ" \
--lock-text="Locking..." \
--lockfailed-text="Failed to lock" \
--radius 135 \
--ring-width 9.0 \
--screen 0 \
--clock	\
--indicator \
--time-str="%I:%M %p" \
--date-str="%b %d, %G" \

rm ${images[@]} 
rm $lockimage
