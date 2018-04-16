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
INPUT_FILE=$1
SCRIPT_FOLDER=$2
ROOT=$3
N_PARTS=$4
LANGUAGE=$5
LEVEL=$6
#######################

#derive local vars
RESULT_FOLDER="$ROOT/$LANGUAGE/$LEVEL" 

#create a result folder, with language and level subfolders
mkdir -p $RESULT_FOLDER
 
# extract input from rda file, without children utterances, clean and save both versions of the file (the full one, and the one without foreign words)
Rscript $SCRIPT_FOLDER/sel_clean.r $INPUT_FILE $RESULT_FOLDER $LANGUAGE $LEVEL

# cut the ensuing file into 10 subparts
for PREPOSITION in noforeign full ; do
	bash $SCRIPT_FOLDER/phonologize_newtags.sh $LANGUAGE $SCRIPT_FOLDER $RESULT_FOLDER/${PREPOSITION}.txt

	bash $SCRIPT_FOLDER/cut.sh $RESULT_FOLDER/${PREPOSITION}-tags.txt $RESULT_FOLDER/split/ $N_PARTS
done


# analyze each of the subparts 
for VERSION in $RESULT_FOLDER/concatenate/*/${PREPOSITION}_${LANGUAGE}_${LEVEL}.txt
do
	THISGOLD="$VERSION/clean_corpus-gold.txt"
	THISTAG="${THISGOLD/gold/tags}"


######## STOPPED HERE!! I realized I'm not doing this right because I didn't get the organization

	LANG=C
	LC_CTYPE=C

	#Precautionary measures
	pcregrep --color='auto' -n '[^\x00-\x7F]' $VERSION/clean_corpus-gold.txt
	#sed -i -e 's/[^\x00-\x7F]//g' -e 's/^\s//g' -e 's/^;esyll ;eword //g'  $VERSION/clean_corpus-gold.txt #no need to use, only precautionary
	#sed -i -e 's/[^\x00-\x7F]//g' -e 's/^\s//g' -e 's/^;esyll ;eword //g'  $VERSION/clean_corpus-tags.txt #no need to use, only precautionary

		

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


