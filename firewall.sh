#!/bin/bash

while [ true ]; do
	cat /etc/mtab | grep media 
	if [ $? -eq 0 ]; then
		USBSERIAL=$(dmesg | tail -n20 | grep ": Serial" | awk '{print $6}' )
		if [ $(grep -c $USBSERIAL whitelist.txt) -eq 0 ];then
			echo "USB with serialnumber:m$USBSERIAL detected select a choice"
			echo "1)F*** that sh**  2)yea yea Its mine  3)Add to whitelist"
			read opcion
				case $opcion in
					1) sudo eject /dev/sdc1;;
					2) echo "Be careful of you decisions nigga";;
					3) echo $USBSERIAL >> whitelist.txt
						echo "$USBSERIAL Added to whitelist";;
					*) echo "WTF is that";;
				esac
			break;
		else
			echo "USB : $USBSERIAL detected"
			echo " 1)yea yea yea It's my USB 2)F*** that sh**"
			read opcion 
			case $opcion in
				1) echo "Be wise dont trust USB's";;
				2) echo "USB deleted from white list and ejected"
					sudo eject /dev/sdc1
					sed -i '/[$USBSERIAL]/d' whitelist.txt;;
				3) echo "WTF is that";;
			esac
			sudo dmesg --clear
			break;
		fi
	fi
done
