#!/bin/bash
# main pipeline within a corpus and level
# By Georgia Loukatou georgialoukatou@gmail.com
# Last changed Alex Cristia alecristia@gmail.com 2018-04-13

#- passing some parameters
#$-S /bin/bash        # the shell used
#$-N big_wrap  # gives the name of the job
#$-pe openmpi_ib 1   # nb of cores required (this is purely declarative)
#$-j yes   # join stdout and stderr in the same file
#$-q cpu   # name of the queue (cpu, gpu, all)
#$-cwd     # puts the logs in the current directory

#- some messages to the user
/bin/echo Running on host: `hostname`.
/bin/echo In directory: `pwd`
echo QUEUE=$QUEUE
echo NSLOTS=$NSLOTS
/bin/echo Starting on: `date`

#- some back magic
#. /etc/profile.d/modules.sh

######################## Get info from upstream
#file/folder information
SCRIPT_FOLDER=$1
RESULT_FOLDER=$2
N_PARTS=$3
SELECTION=$4
#######################

if [ "$N_PARTS" -gt 1 ] ; then
   PATTERN="$RESULT_FOLDER/$SELECTION/*/tags.txt"
else
   PATTERN="$RESULT_FOLDER/${SELECTION}-tags.txt"
fi

# analyze each of the subparts 
for THISTAG in $PATTERN
do
  	FOLDER=`dirname $THISTAG`
	OUT="$FOLDER/$SELECTION/results"
	mkdir -p $OUT
	THISGOLD="${THISTAG/tags/gold}"
	THISSTAT="${THISTAG/tags/stats}"

echo $THISGOLD $out

	#statistics
	wordseg-stats $THISTAG -o $THISSTAT


	cat $THISTAG | wordseg-prep -u syllable --gold $THISGOLD > $OUT/prepared_syll.txt
	cat $THISTAG | wordseg-prep -u phone > $OUT/prepared.txt

	cat $OUT/prepared_syll.txt | wordseg-tp -t relative -p forward > $OUT/segmented.ftp_rel.txt
	cat $OUT/segmented.ftp_rel.txt | wordseg-eval $THISGOLD > $OUT/eval.ftp_rel.txt

	cat $OUT/prepared_syll.txt | wordseg-tp -t absolute -p forward > $OUT/segmented.ftp_abs.txt
	cat $OUT/segmented.ftp_abs.txt | wordseg-eval $THISGOLD > $OUT/eval.ftp_abs.txt

	cat $OUT/prepared_syll.txt | wordseg-tp -t relative -p backward > $OUT/segmented.btp_rel.txt
	cat $OUT/segmented.btp_rel.txt | wordseg-eval $THISGOLD > $OUT/eval.btp_rel.txt

	cat $OUT/prepared_syll.txt | wordseg-tp -t absolute -p backward > $OUT/segmented.btp_abs.txt
	cat $OUT/segmented.btp_abs.txt | wordseg-eval $THISGOLD > $OUT/eval.btp_abs.txt

	wordseg-dibs -t phrasal -o $OUT/segmented.dibs.txt $OUT/prepared.txt  $THISTAG
	wordseg-eval -o $OUT/eval.dibs.txt $OUT/segmented.dibs.txt $THISGOLD

#	wordseg-ag $OUT/prepared.txt $SCRIPT_FOLDER/Colloc0_acqdiv.lt Colloc0 -n 2000 -vv > $OUT/segmented.ag.txt
#	cat $OUT/segmented.ag.txt | wordseg-eval $THISGOLD > $OUT/eval.ag.txt

	#baselines
	cat $OUT/prepared_syll.txt | wordseg-baseline -P 1 > $OUT/segmented.baselinesyll1.txt
	cat $OUT/segmented.baselinesyll1.txt | wordseg-eval $THISGOLD > $OUT/eval.baselinesyll1.txt

	cat $OUT/prepared_syll.txt | wordseg-baseline -P 0 > $OUT/segmented.baselinesyll0.txt
	cat $OUT/segmented.baselinesyll0.txt | wordseg-eval $THISGOLD > $OUT/eval.baselinesyll0.txt

	cat $OUT/prepared_syll.txt | wordseg-baseline -P 0.5 > $OUT/segmented.baselinesyll0.5.txt
	cat $OUT/segmented.baselinesyll0.5.txt | wordseg-eval $THISGOLD > $OUT/eval.baselinesyll0.5.txt

	echo "done segmentation"

done



