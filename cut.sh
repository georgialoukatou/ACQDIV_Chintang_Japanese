#!/bin/sh
# This script cuts a corpus into a chosen number of parts
# Laia Fibla laia.fibla.reixachs@gmail.com 2017-03-22
# Edits Georgia Loukatou
# Last edits Alex Cristia alecristia@gmail.com 2018-04-13

##### Variables #####
input_file=$1 		# path to the corpus that will be cut up
output_folder=$2 	# path to the folder where you want to store the subparts
divide=$3 		# number of sub-parts
####################

mkdir -p ${output_folder}

file_name=`basename $input_file`

max=`wc -l $input_file | awk '{print $1}'`
n=$(( $max / $divide ))

i=0
while [ $i -lt $divide ]
do
  echo in while $i
  ini=$(( $i * $n + 1 ))
  fin=$(( $ini + $n - 1 ))

  echo sed -n ${ini},${fin}p $input_file > ${output_folder}/${i}/${file_name}
  i=$(($i + 1 ))
done

echo $output

