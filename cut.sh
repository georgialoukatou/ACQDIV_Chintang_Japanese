#!/bin/sh
# This script cuts a corpus into a chosen number of parts
# Laia Fibla laia.fibla.reixachs@gmail.com 2017-03-22
# Edits Georgia Loukatou
# Last edits Alex Cristia alecristia@gmail.com 2018-04-13

##### Variables #####
input_file=$1 		# path to the corpus that will be cut up
divide=$2 		# number of sub-parts
####################
if [ $divide -gt 1 ] ; then

	ROOT=$(dirname "$input_file")
	KEYNAME=$(basename "$input_file" -tags.txt)
	output_folder=$ROOT/$KEYNAME

	max=`wc -l $input_file | awk '{print $1}'`
	n=$(( $max / $divide ))

	i=0
	while [ $i -lt $divide ]
	do
	  echo in while $i

	  mkdir -p ${output_folder}_part${i}/
	  ini=$(( $i * $n + 1 ))
	  fin=$(( $ini + $n - 1 ))

	  sed -n ${ini},${fin}p $input_file > ${output_folder}_part${i}/tags.txt
	  i=$(($i + 1 ))
	done
	echo done cutting
else
	echo no cutting necessary
fi

