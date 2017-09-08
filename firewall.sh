#!/bin/bash

while [ true ]; do
	cat /etc/mtab | grep media 
	if [ $? -eq 0 ]; then
		USBSERIAL=$(dmesg | tail -n20 | grep ": Serial" | awk '{print $6}' )
		if [ $(grep -c $USBSERIAL blacklist.txt) -eq 0 ];then
			pw=$(zenity --password)
			echo $pw | sudo eject /dev/sdb1
		elif [ $(grep -c $USBSERIAL whitelist.txt) -eq 0 ];then
				CHOICE=$(zenity --list --height=220 --title='New USB detected' --text='Do you want to: ' --column "Choice" "F*** that sh**" "Give access once" "Add to white list" "Add to black list")
				case $CHOICE in
					"F*** that sh**")
						pw=$(zenity --password)
						echo $pw | sudo eject /dev/sdb1	
					;;
					"Add to white list")
						zenity --warning --text="You have to remove manually from white list if you want"
						echo $USBSERIAL>>whitelist.txt
					;;
					"Add to black list")
						echo $USBSERIAL>>blacklist.txt
					;;
				esac	
		elif [ $(grep -c $USBSERIAL whitelist.txt) -ne 0 ];then
			notify-send -t 1 "USB in white list connected"
		fi	
	fi
	done


