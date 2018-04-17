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

if [ "$N_PARTS" -gt 1 ]
   PATTERN="$RESULT_FOLDER/$SELECTION/*/tags.txt"
else
   PATTERN="$RESULT_FOLDER/$SELECTION/tags.txt"
fi

# analyze each of the subparts 
for THISTAG in $PATTERN
do
	THISGOLD="$VERSION/clean_corpus-gold.txt"
	THISTAG="${THISGOLD/gold/tags}"


		

	mkdir $VERSION/results

	cat $THISTAG | wordseg-prep -u syllable --gold /$VERSION/gold.txt > /$VERSION/prepared_syll.txt
	cat $THISTAG | wordseg-prep -u phone > /$VERSION/prepared.txt

	cat $VERSION/prepared_syll.txt | wordseg-tp -t relative -p forward > $VERSION/results/segmented.ftp_rel.txt
	cat $VERSION/results/segmented.ftp_rel.txt | wordseg-eval $VERSION/gold.txt > $VERSION/results/eval.ftp_rel.txt

	cat $VERSION/prepared_syll.txt | wordseg-tp -t absolute -p forward > $VERSION/results/segmented.ftp_abs.txt
	cat $VERSION/results/segmented.ftp_abs1.txt | wordseg-eval $VERSION/gold.txt > $VERSION/results/eval.ftp_abs.txt

	cat $VERSION/prepared_syll.txt | wordseg-tp -t relative -p backward > $VERSION/results/segmented.btp_rel.txt
	cat $VERSION/results/segmented.btp_rel.txt | wordseg-eval $VERSION/gold.txt > $VERSION/results/eval.btp_rel.txt#

	cat $VERSION/prepared_syll.txt | wordseg-tp -t absolute -p backward > $VERSION/results/segmented.btp_abs.txt
	cat $VERSION/results/segmented.btp_abs.txt | wordseg-eval $VERSION/gold.txt > $VERSION/results/eval.btp_abs.txt


	head -"${size}" $THISTAG > $VERSION/results/train.txt
	head -200  $THISTAG > $VERSION/results/train200.txt

	wordseg-dibs -t phrasal -o $VERSION/results/segmented.dibs.txt $VERSION/results/prepared.txt  $THISTAG
	wordseg-eval -o $VERSION/results/eval.dibs.txt $VERSION/results/segmented.dibs.txt $VERSION/results/gold.txt

	wordseg-dibs -t phrasal -o $VERSION/results/segmented.dibs200.txt $VERSION/results/prepared.txt  $VERSION/results/train200.txt
	wordseg-eval -o $VERSION/results/eval.dibs200.txt $VERSION/results/segmented.dibs200.txt $VERSION/results/gold.txt


	wordseg-ag $VERSION/results/prepared.txt $SCRIPT_FOLDER/Colloc0_acqdiv.lt Colloc0 -n 2000 -vv > ${VERSION}/results/segmented.ag.txt
	cat $VERSION/results/segmented.ag.txt | wordseg-eval $VERSION/results/gold.txt > $VERSION/results/eval.ag.txt

	#baselines
	cat ${VERSION}/prepared_syll.txt | wordseg-baseline -P 1 > ${VERSION}/results/segmented.baselinesyll1.txt
	cat ${VERSION}/results/segmented.baselinesyll1.txt | wordseg-eval ${VERSION}/gold.txt > ${VERSION}/results/eval.baselinesyll1.txt

	cat ${VERSION}/prepared_syll.txt | wordseg-baseline -P 0 > ${VERSION}/results/segmented.baselinesyll0.txt
	cat ${VERSION}/results/segmented.baselinesyll0.txt | wordseg-eval ${VERSION}/gold_tp.txt > ${VERSION}/results/eval.baselinesyll0.txt

	cat ${VERSION}/prepared_syll.txt | wordseg-baseline -P 0.5 > ${VERSION}/results/segmented.baselinesyll0.5.txt
	cat ${VERSION}/results/segmented.baselinesyll0.5.txt | wordseg-eval ${VERSION}/gold_tp.txt > ${VERSION}/results/eval.baselinesyll0.5.txt

	#statistics
	wordseg-stats ${VERSION}/clean_corpus-tags.txt -o ${VERSION}/descript_stats.txt




	echo "done segmentation"

done

bash $SCRIPT_FOLDER/collapse_results.sh $LANGUAGE $LEVEL $ROOT
cat $ROOT/merged*.csv >> $ROOT/merged_Chintang_Japanese.csv
sed -i -e 's/utterance_morphemes/morphemes/g' -e 's/utterance/words/g'  $ROOT/regression_Chintang_Japanese.csv
sed -i 1i"language,algorithm,level,fscore,subalgorithm,subcorpora" $ROOT/merged_Chintang_Japanese.csv


