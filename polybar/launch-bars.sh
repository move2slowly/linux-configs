#! /bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		MONITOR=$m polybar Bottom-Left &
		MONITOR=$m polybar Bottom-Center &
		MONITOR=$m polybar Bottom-Right &
done

polybar eDP-1-Center &
polybar eDP-1-Right &
if [[ $(xrandr -q | grep 'HDMI-A-0 connected') ]]; then
	polybar HDMI-A-0 &
	polybar eDP-1-Left-Short &
else
	polybar eDP-1-Left &
fi

