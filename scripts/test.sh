#!/bin/sh



echo "Update:$( date )" > /tmp/${3:-arg3}.txt
echo "${1:-arg1}, ${2:-arg2}" >> /tmp/${3:-arg3}.txt
