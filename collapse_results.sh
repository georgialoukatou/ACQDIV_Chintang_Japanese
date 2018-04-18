#!/bin/bash

RESFOLDER=$1 

rm $RESFOLDER/results/allresults.txt

for THISRES in $RESFOLDER/results/eval* $RESFOLDER/*/results/eval*
do

echo writing into $RESFOLDER/results/allresults.txt
	# flip the column within each result into a comma-separated horizontal vector
	res=`cat $THISRES | awk '{print $2}' | tr '\n' ','`  
	echo "$THISRES,$res" >> $RESFOLDER/results/allresults.txt
done
