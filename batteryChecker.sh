#! /bin/bash

notifyIfLow() {
	AC=`cat /sys/class/power_supply/AC/online`
	if [ $AC -eq 1 ]; then
		return
	fi
	NOW=`cat /sys/class/power_supply/BAT0/energy_now`
	MAX=`cat /sys/class/power_supply/BAT0/energy_full_design`
	COC=$((100*$NOW/$MAX));

	USER=$(who | awk '/:0/{print $1; exit;}')

	if [ $COC -lt 5 ]; then
		sudo -u $USER DISPLAY=":0" notify-send -u critical "Battery is critical, going to hiberate now"
		sudo -u $USER  pm-hibernate
	elif [ $COC -lt 7 ]; then
		sudo -u $USER DISPLAY=":0" notify-send -u critical "Battery is critical!!! Going into hibernate soon"
	elif [ $COC -lt 15 ]; then
		sudo -u $USER DISPLAY=":0" notify-send -u critical "Battery is almost empty!!!"
	fi
}

while true; do
	notifyIfLow;
	sleep 60;
done

