#!/usr/bin/sh

TASK="task"

OVERDUE="💀"
URGENT="⚠️"
DUETOMORROW="⌛"
DUETODAY="🙀"

if [ `$TASK +READY +OVERDUE count` -gt "0" ]; then
	echo -e $OVERDUE
elif [ `$TASK +READY +DUETODAY count` -gt "0" ]; then
	echo $DUETODAY
elif [ `$TASK +READY +TOMORROW count` -gt "0" ]; then
	echo $DUETOMORROW
elif [ `$TASK +READY urgency > 10 count` -gt "0" ]; then
	echo $URGENT
fi
