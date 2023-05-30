#!/usr/bin/sh

TASK="task"

OVERDUE="💀"
URGENT="⚠️"
DUETOMORROW="⌛"
DUETODAY="🙀"
RESULT=""

if [ `$TASK +READY +OVERDUE count` -gt "0" ]; then
	RESULT=$OVERDUE
elif [ `$TASK +READY +DUETODAY count` -gt "0" ]; then
	RESULT=$DUETODAY
elif [ `$TASK +READY +TOMORROW count` -gt "0" ]; then
	RESULT=$DUETOMORROW
elif [ `$TASK +READY urgency > 10 count` ]; then
	RESULT=$URGENT
else echo ""
fi

RED='\033[0;31m'
NC='\033[0m' # No Color
if [ `$TASK +ACTIVE count` -eq 0 ]; then
   RESULT=$RESULT 
else RESULT=$RESULT"T"
fi

COLOR=#ff0000
echo "<txt><span foreground=\"$COLOR\">$RESULT</span></txt>"
