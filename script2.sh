#!/bin/bash
mkdir temp2925 2>/dev/null
mkdir temp2925/temp 2>/dev/null
mkdir temp2925/assignments 2>/dev/null
tar -xzf $1 -C temp2925/temp
find temp2925/temp -name "*.txt" > temp2925/sites.txt
while read line; do
	while read site; do
		TEMPVAR=`echo $site | head -c 5`
		if [[ $TEMPVAR = "https" ]]; then
			DIRNAME=`basename $site | cut -d "." -f1`
			mkdir temp2925/assignments/$DIRNAME 2>/dev/null
			git clone $site &>/dev/null temp2925/assignments/$DIRNAME
			if [ $? -eq 0 ]; then
				echo "$site: Cloning OK"
				rm -rf temp2925/assignments/$DIRNAME/.git
			else
				echo "$site: Cloning FAILED"
			fi
			break
		fi
	done < $line
done < temp2925/sites.txt
for DIRECTORY in `ls temp2925/assignments/`; do
	NODIRECTORIES=`find temp2925/assignments/$DIRECTORY/ -type d | tail -n +2 | wc -l`
	NOFILES=`find temp2925/assignments/$DIRECTORY/ -type f | wc -l`
	NOTXTS=`find temp2925/assignments/$DIRECTORY/ -type f -name "*.txt" | wc -l`
	NOOTHER=$(($NOFILES-$NOTXTS))
	echo "$DIRECTORY:"
	echo "Number of directories: $NODIRECTORIES"
	echo "Number of txt files: $NOTXTS"
	echo "Number of other files: $NOOTHER"
	if [ $NODIRECTORIES -eq 1 ] && [ $NOTXTS -eq 3 ] && [ $NOOTHER -eq 0 ]; then
		if [ -e temp2925/assignments/$DIRECTORY/dataA.txt ] && [ -d temp2925/assignments/$DIRECTORY/more ] && [ -e temp2925/assignments/$DIRECTORY/more/dataB.txt ] && [ -e temp2925/assignments/$DIRECTORY/more/dataC.txt ]; then
			echo "Directory structure is OK."
		else
			echo "Directory structure is NOT OK."
		fi
	else
		echo "Directory structure is NOT OK."
	fi
done
