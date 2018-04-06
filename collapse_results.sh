#!/bin/bash


LANGUAGE=$1 
LEVEL=$2 
ROOT=$3

DIR="${ROOT}/${1}/${2}"
RES="${DIR}/results"

mkdir $DIR/results

for SEGMENT in $DIR/concatenate/*
do

echo $SEGMENT

#sed "s/$/,FTP_rel/g" < $SEGMENT/results/eval.ftp_rel*.txt > $SEGMENT/results/eval.ftp_rel_type.txt
#sed "s/$/,BTP_rel/g" < $SEGMENT/results/eval.btp_rel*.txt > $SEGMENT/results/eval.btp_rel_type.txt
#sed "s/$/,BTP_abs/g" < $SEGMENT/results/eval.btp_abs*.txt > $SEGMENT/results/eval.btp_abs_type.txt
#sed "s/$/,FTP_abs/g" < $SEGMENT/results/eval.ftp_abs*.txt > $SEGMENT/results/eval.ftp_abs_type.txt

#cat ${SEGMENT}/results/eval.*type.txt >> ${SEGMENT}/results/eval.tp_type.txt
#sed -e  's/\s/,/g' -e '/^token_fscore/!d' < $SEGMENT/results/eval.tp_type.txt > $SEGMENT/results/temp0.csv
#cut -d, -f1 --complement < $SEGMENT/results/temp0.csv > $SEGMENT/results/temp1.csv
#sed "s/^/$LANGUAGE,TPs,$LEVEL,/g" < $SEGMENT/results/temp1.csv > $SEGMENT/results/eval.tp_type.csv

#sed "s/$/,AGu/g" < $SEGMENT/results/eval.ag.txt > $SEGMENT/results/eval.ag_type.txt
#sed -e  's/\s/,/g' -e '/^token_fscore/!d' < $SEGMENT/results/eval.ag_type.txt > $SEGMENT/results/temp2.csv
#cut -d, -f1 --complement < $SEGMENT/results/temp2.csv > $SEGMENT/results/temp3.csv
#sed "s/^/$LANGUAGE,AG,$LEVEL,/g" < $SEGMENT/results/temp3.csv > $SEGMENT/results/eval.ag_type.csv

#sed "s/$/,DiBS/g" < $SEGMENT/results/eval.dibs.txt > $SEGMENT/results/eval.dibs_type.txt
#sed -e  's/\s/,/g' -e '/^token_fscore/!d' < $SEGMENT/results/eval.dibs_type.txt > $SEGMENT/results/temp4.csv
#cut -d, -f1 --complement < $SEGMENT/results/temp4.csv > $SEGMENT/results/temp5.csv
#sed "s/^/$LANGUAGE,DiBS,$LEVEL,/g" < $SEGMENT/results/temp5.csv > $SEGMENT/results/eval.dibs_type.csv

#rm $SEGMENT/results/temp*.csv
done


#cat $DIR/concatenate/*/results/eval.tp_type.csv >> $DIR/results/all_eval.tp_type.csv
#cat $DIR/concatenate/*/results/eval.ag_type.csv >> $DIR/results/all_eval.ag_type.csv
#cat $DIR/concatenate/*/results/eval.dibs_type.csv >> $DIR/results/all_eval.dibs_type.csv


########################merge results

cat ${RES}/all_eval*.csv >> ${RES}/merged_eval_${LANGUAGE}_${LEVEL}.csv
sed -i 1i"language,algorithm,level,fscore,subalgorithm" ${RES}/merged_eval_${LANGUAGE}_${LEVEL}.csv

cp ${RES}/merged_eval_${LANGUAGE}_${LEVEL}.csv  ${ROOT}


################################corpus descriptives
#sed '/^\(corpus entropy\|words token\/types\|words tokens\/utt\|syllables tokens\/word\|syllables tokens\/utt\|syllables token\/types\|phones tokens\/utt\|phones tokens\/syllable\|phones tokens\/word\|phones token\/types\)/!d' < $SEGMENT/descript_stats.txt >$SEGMENT/descript_regression.txt
#rm descript_regression1.txt
#rm $SEGMENT/descript_regression2.txt
#rm $SEGMENT/rows.txt
#sed '/^\(corpus entropy\|word\)/!d' <$SEGMENT/descript_stats1.txt >$SEGMENT/descript_regression.txt
#sed -i -e 's/s e/s_e/g' -e 's/s t/s_t/g' $SEGMENT/descript_regression.txt
#sed -i  's/\s/,/g' $SEGMENT/descript_regression.txt
#cut -d, -f1 --complement < $SEGMENT/descript_regression.txt > $SEGMENT/descript_regression2.txt
#echo $(cat $SEGMENT/descript_regression2.txt) >> $SEGMENT/rows.txt
#sed -i 's/\s/,/g'  $SEGMENT/rows.txt


#################################average 4 TP
#cat ${SEGMENT}/results/eval.*_*.txt >> ${SEGMENT}/results/temp.txt
#sed -e  's/\s/,/g' -e '/^type_fscore/!d' < $SEGMENT/results/temp.txt > $SEGMENT/results/temp.csv
#cut -d, -f1 --complement < $SEGMENT/results/temp.csv > $SEGMENT/results/temp1.csv
#awk '{s+=$1} {av=0} {av=s/4} END {print av}' < $SEGMENT/results/temp1.csv  > $SEGMENT/results/temp2.csv
#sed "s/^/$LANGUAGE,TPs,$LEVEL,/g" < $SEGMENT/results/temp2.csv > $SEGMENT/results/eval.tp.csv
#

#################Old wordseg
#sed -e  's/\s/,/g' -e '/token/d' -e "s/^/$LANGUAGE,AGu,$LEVEL,/g" < ${RES}/all_eval.ag.txt > ${RES}/test.csv
#cut -d, -f5-9 --complement < ${RES}/test.csv > ${RES}/all_eval.ag.csv
#sed -i "s/$/,AGu/g" ${RES}/all_eval.ag.csv
