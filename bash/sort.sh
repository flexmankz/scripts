#!/bin/bash

##################################
path=/tmp/testdir/2012
age=20
lcount=5
##################################

old="/tmp/oldest"
new="/tmp/newest"

find $path -type f -mtime +$age -printf '%T@ %p\n' | sort -n > $old
find $path -type f -mtime -$age > $new

count=$(wc -l $new | cut -d ' ' -f 1)
countold=$(wc -l $old | cut -d ' ' -f 1)
if [[ $countold -ne 0 ]]; then
	if [[ $count -gt $lcount ]]; then
		while read line; do
			rm -rf $line
		done <<< $(cat $old | cut -d ' ' -f 2)
	else
		let need=$lcount-$count
		if [[ $countold -lt $need ]]; then
			need=$countold
		fi
		if [[ $need -le 0 ]]; then
			echo qq
			exit 1
		fi
		tail -n $need $old >> $new
		sed -i 1,${need}d $old
		while read line; do
			rm -rf $line
		done <<< $(cat $old | cut -d ' ' -f 2)
	fi
fi

rm -f $new $old
