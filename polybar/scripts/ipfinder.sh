#!/bin/sh

REFRESH=1
HARD_REFRESH=60

# Icons
VPN_UP="󰤪"
#VPN_DOWN="󱛎"
VPN_DOWN="󰤩"
INTERNET_DOWN="󰤮"
STATE=$INTERNET_DOWN

while :; do
	tailscale status | grep -q "exit node" && NEW_STATE=$VPN_UP || NEW_STATE=$VPN_DOWN 
	nmcli | grep -q "^wlan0: connected" || NEW_STATE=$INTERNET_DOWN
	if [ $NEW_STATE == $INTERNET_DOWN ]; then
		echo $NEW_STATE'  Not connected'
	elif [ $NEW_STATE != $STATE ]; then
		echo "refreshing..."
		sleep 0.5
		echo $NEW_STATE" " $(curl -sf icanhazip.com)
		TIME=0
	elif [ $TIME -gt $HARD_REFRESH ]; then
		echo $NEW_STATE" "$(curl -sf icanhazip.com)
		TIME=0
	fi
	STATE=$NEW_STATE
	TIME=$((TIME+REFRESH))
	#echo $TIME
	sleep $REFRESH
done
