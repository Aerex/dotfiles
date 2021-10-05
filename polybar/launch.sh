#!/bin/bash
#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
#polybar example &
export FC_DEBUG=1

for i in $(polybar -m | awk -F: '{print $1}'); do MONITOR=$i polybar full -c ~/.config/polybar/config & done
feh --bg-scale ~/Downloads/Wallpapers/gokugohan.png	

echo "Bars launched..."
