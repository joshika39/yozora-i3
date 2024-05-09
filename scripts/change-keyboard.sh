#!/usr/bin/bash

keyboard=$( cat $HOME/.keyboard )

keyboard_count=5

[ ! "$keyboard" -eq "$keyboard" ] 2>/dev/null && keyboard=0 

[[ -z $keyboard ]] && keyboard=0

 (( keyboard+= 1 ))

if (( $keyboard >= $keyboard_count )); then
	keyboard=0
fi

declare -a keyboard_list
keyboard_list[0]="xkb:us::eng"
keyboard_list[1]="anthy"
keyboard_list[2]="xkb:hu:101_qwerty_comma_nodead:hun"
keyboard_list[3]="xkb:rs:latin:srp"
keyboard_list[4]="xkb:rs::srp"

ibus engine ${keyboard_list[$keyboard]}

echo $keyboard > $HOME/.keyboard
