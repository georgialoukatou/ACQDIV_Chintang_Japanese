#!/bin/bash
# main pipeline within a corpus and level
# By Georgia Loukatou georgialoukatou@gmail.com
# Last changed Alex Cristia alecristia@gmail.com 2018-04-13

######################## Get info from upstream
#file/folder information
SCRIPT_FOLDER=$1
RESULT_FOLDER=$2
N_PARTS=$3
SELECTION=$4
#######################


module load python-anaconda boost     
source activate /cm/shared/apps/python-anaconda/envs/wordseg

if [ "$N_PARTS" -gt 1 ] ; then
   PATTERN="$RESULT_FOLDER/${SELECTION}_part*/tags.txt"
else
   PATTERN="$RESULT_FOLDER/${SELECTION}-tags.txt"
fi

# analyze each of the subparts 
for THISTAG in $PATTERN
do
  	FOLDER=`dirname $THISTAG | sed 's/.*Chintang/C/g' | sed 's/.*Japanese/J/g'| sed 's/morphemes/_m/g' | sed 's/words/_w/g' | tr -d "/"`
	PREP_SYLL="${THISTAG/tags/prepared_s}"
	PREP_PHONE="${THISTAG/tags/prepared_p}"
	THISGOLD="${THISTAG/tags/gold}"
	THISSTAT="${THISTAG/tags/stats}"

echo $THISGOLD $out

	#statistics
	wordseg-stats $THISTAG -o $THISSTAT


	cat $THISTAG | wordseg-prep -u syllable --gold $THISGOLD > $PREP_SYLL
	cat $THISTAG | wordseg-prep -u phone > $PREP_PHONE

	cat $PREP_SYLL | wordseg-tp -t relative -p forward > ${THISTAG}_segmented.ftp_rel.txt
	cat ${THISTAG}_segmented.ftp_rel.txt | wordseg-eval $THISGOLD > ${THISTAG}_eval.ftp_rel.txt

	cat $PREP_SYLL | wordseg-tp -t absolute -p forward > ${THISTAG}_segmented.ftp_abs.txt
	cat ${THISTAG}_segmented.ftp_abs.txt | wordseg-eval $THISGOLD > ${THISTAG}_eval.ftp_abs.txt

	cat $PREP_SYLL | wordseg-tp -t relative -p backward > ${THISTAG}_segmented.btp_rel.txt
	cat ${THISTAG}_segmented.btp_rel.txt | wordseg-eval $THISGOLD > ${THISTAG}_eval.btp_rel.txt

	cat $PREP_SYLL | wordseg-tp -t absolute -p backward > ${THISTAG}_segmented.btp_abs.txt
	cat ${THISTAG}_segmented.btp_abs.txt | wordseg-eval $THISGOLD > ${THISTAG}_eval.btp_abs.txt

	wordseg-dibs -t phrasal -o ${THISTAG}_segmented.dibs.txt $PREP_PHONE  $THISTAG
	wordseg-eval -o ${THISTAG}_eval.dibs.txt ${THISTAG}_segmented.dibs.txt $THISGOLD

        echo "module load python-anaconda boost && \
          source activate /cm/shared/apps/python-anaconda/envs/wordseg && \
          cat $PREP_PHONE | wordseg-ag $SCRIPT_FOLDER/Colloc0_acqdiv.lt Colloc0 --njobs 8 | tee ${THISTAG}_segmented.ag.txt | wordseg-eval $THISGOLD  > ${THISTAG}_eval.ag.txt || exit 1"   | qsub -S /bin/bash -V -cwd -j y -pe mpich 8 -N acqdiv_$FOLDER 

	#baselines
	cat $PREP_SYLL | wordseg-baseline -P 1 > ${THISTAG}_segmented.baselinesyll1.txt
	cat ${THISTAG}_segmented.baselinesyll1.txt | wordseg-eval $THISGOLD > ${THISTAG}_eval.baselinesyll1.txt

	cat $PREP_SYLL | wordseg-baseline -P 0 > ${THISTAG}_segmented.baselinesyll0.txt
	cat ${THISTAG}_segmented.baselinesyll0.txt | wordseg-eval $THISGOLD > ${THISTAG}_eval.baselinesyll0.txt

	echo "done segmentation"

done

source deactivate
