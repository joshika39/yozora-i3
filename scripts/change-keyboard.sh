#!/usr/bin/bash

keyboard=$( cat $HOME/.keyboard )

[ ! "$keyboard" -eq "$keyboard" ] 2>/dev/null && keyboard=0 

[[ -z $keyboard ]] && keyboard=0

 (( keyboard+= 1 ))

if (( $keyboard >= 4 )); then
	keyboard=0
fi


case $keyboard in
	0 )	ibus engine xkb:us::eng ;;
	1 )	ibus engine anthy ;;
	2 )	ibus engine xkb:hu:101_qwerty_comma_nodead:hun ;;
	3 )	ibus engine xkb:rs:latin:srp ;;
	* )	echo error > /tmp/lang.txt ;;
esac

echo $keyboard > $HOME/.keyboard
