#!/bin/bash

#MAX BRIGHT STATUS 
BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/brightness)
MAX_BRIGHTNESS=4000
STATUS=$(node -e "console.log(parseInt(($BRIGHTNESS/$MAX_BRIGHTNESS)*100))")
STATUS=$(node -e "console.log($STATUS > 100 ? 100 : $STATUS)")
echo $STATUS
