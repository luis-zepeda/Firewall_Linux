#!/bin/bash

while [ true ]; do
	cat /etc/mtab | grep media 
	if [ $? -eq 0 ]; then
		USBSERIAL=$(dmesg | tail -n20 | grep ": Serial" | awk '{print $5}' )
		if [ $(grep -c $USBSERIAL whitelist.txt) -eq 0 ];then
			CHOICE=$(zenity --list --height=220 --title='New USB detected' --text='Do you want to: ' --column "Choice" "F*** that sh**" "Give access once" "Add to white list" "Add to black list")
			case $CHOICE in
				"F*** that sh**")
					sudo eject /dev/sdb1
				;;
				"Give access once"
					sudo dmesg --clear
				;;
				"Add to white list"
					echo $USBSERIAL>>whitelist.txt
					sudo dmseg --clear
				;;
				"Add to black list"
					echo $USBSERIAL>>blacklist.txt
				;;
			esac	
		else
			zenity --question --text 'It is yours' --title 'New USB detected' --ok-label='YEA it is mine'\
			--cancel-label='F*** that'
			if [ $? -eq 0 ]; then
				zenity --warning --text="Be wise don't trust USB's"
				sudo dmesg --clear
			else
				zenity --warning --text="USB deleted from white list and ejected"
					sudo eject /dev/sdb1
					sed -i '/[$USBSERIAL]/d' whitelist.txt
			fi
		fi
	fi
done
