#!/bin/bash

while [ true ]; do
	detect=dmesg | tail -n20 | grep -s "USB Mass Storage device detected"
	echo $detect
	if [ -n $detect ]; then
		USBSERIAL=$(dmesg | tail -n20 | grep ": Serial" | awk '{print $6}' )
		echo "USB with serialnumber: $USBSERIAL detected select a choice"
		echo "1) Eject inmidiatly  2) Let it be  3) Add to whitelist"
		read opcion
		case $opcion in
			1) eject /dev/sdc1;;
			2) echo "doing nothing";;
			3) echo $USBSERIAL >> whitelist.txt;;
			*) echo "Number not valid";;
		esac
	fi
done
