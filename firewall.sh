#!/bin/bash

while [ true ]; do
	cat /etc/mtab | grep media 
	if [ $? -eq 0 ]; then
		USBSERIAL=$(dmesg | tail -n20 | grep ": Serial" | awk '{print $6}' )
		MOUNT=$( cat /etc/mtab | grep media | awk '{print $1}' )
		if [ $(grep -c $USBSERIAL blacklist.txt) -eq 0 ];then
			if [ $(grep -c $USBSERIAL whitelist.txt) -eq 0 ];then
				CHOICE=$(zenity --list --height=220 --title='New USB detected' --text='Do you want to: ' --column "Choice" "F*** that sh**" "Give access once" "Add to white list" "Add to black list")
				case $CHOICE in
					"F*** that sh**")
						sudo eject $MOUNT
					;;
					"Give access once")
						sudo dmesg --clear
					;;
					"Add to white list")
						echo $USBSERIAL>>whitelist.txt
						sudo dmseg --clear
					;;
					"Add to black list")
						echo $USBSERIAL>>blacklist.txt
					;;
				esac	
			else
				zenity --question --text 'Still your USB?' --title 'A whitelisted USB was detected' --ok-label='-.- yeah its mine'\
				--cancel-label='F*** NO'
				if [ $? -eq 0 ]; then
					zenity --warning --text="Be wise don't trust USB's"
					sudo dmesg --clear
				else
					sudo eject $MOUNT
					zenity --warning --text="USB deleted from white list and ejected"
					sed -i '/[$USBSERIAL]/d' whitelist.txt
				fi
			fi
		else
			sudo eject $MOUNT
			zenity --warning --text="Intusive USB with serial number: $USBSERIAL being ejected inmediately \ To mount this USB erase it from blacklist.txt"

		fi
	fi
done
