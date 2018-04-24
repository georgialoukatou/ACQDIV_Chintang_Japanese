#!/bin/bash

RESFOLDER=$1 

header="folder \
        token_precision token_recall token_fscore \
        type_precision type_recall type_fscore \
        boundary_precision boundary_recall boundary_fscore \
        boundary_NE_precision boundary_NE_recall boundary_NE_fscore"
header=`echo $header | tr -s ' ' | tr ' ' ','`
echo $header > $RESFOLDER/results.txt

header="folder \
	corpus_nutts corpus_nutts_single_word \
	corpus_mattr corpus_entropy \
	words_tokens words_types words_hapaxes \
	syllables_tokens syllables_types syllables_hapaxes \
	phones_tokens phones_types phones_hapaxes"

header=`echo $header | tr -s ' ' | tr ' ' '\t'`
echo $header > $RESFOLDER/stats.txt


for THISRES in $RESFOLDER/*/*/*eval* $RESFOLDER/*/*/*/*eval*
do

echo writing into $RESFOLDER/results.txt
	# flip the column within each result into a comma-separated horizontal vector
	res=`cat $THISRES | awk '{print $2}' | tr '\n' ',' | sed 's/,$//'`  
	echo "$THISRES,$res" >> $RESFOLDER/results.txt

done

sed  -ni "/0.[0-9]/p"  $RESFOLDER/results.txt

for THISRES in $RESFOLDER/*/*/*stat* $RESFOLDER/*/*/*/*stat*
do

echo writing into $RESFOLDER/results.txt
	# flip the column within each result into a comma-separated horizontal vector
	res=`cat $THISRES | awk '{print $3}' | tr '\n' ',' | sed 's/,$//'`  
	echo "$THISRES,$res" >> $RESFOLDER/stats.txt

done
sed  -ni "/0.[0-9]/p"  $RESFOLDER/stats.txt
