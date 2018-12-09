#!/bin/bash

mkdir temp 2>/dev/null
cat $1 | sort | uniq > temp/temp1.txt
while read line; do
	TEMPVAR=`echo $line | head -c 1`
	if [ $TEMPVAR != "#" ]; then
		TEMPNAME=`echo $line | md5sum | cut -d " " -f1`
		if [ ! -e temp/$TEMPNAME ]; then
			curl -s $line > temp/$TEMPNAME
			if [ $? -eq 0 ]; then
				echo "$line INIT"
				TEMPVAR=`md5sum < temp/$TEMPNAME | cut -d " " -f1`
				echo $TEMPVAR > temp/$TEMPNAME
				echo $line >> temp/$TEMPNAME
			else
				TEMPVAR=`md5sum < temp/$TEMPNAME | cut -d " " -f1`
				echo $TEMPVAR > temp/$TEMPNAME
				echo "$line FAILED" 1>&2
			fi
		else
			AFTER=`curl -s $line | md5sum | cut -d " " -f1`
			BEFORE=`head -n 1 temp/$TEMPNAME`
			if [[ $BEFORE != $AFTER ]]; then
				echo $line
			fi
		fi
	fi
done < temp/temp1.txt
