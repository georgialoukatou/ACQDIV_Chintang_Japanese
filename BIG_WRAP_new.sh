#!/bin/bash

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

########################[1] COMPLETE
#parameters
LANGUAGE="Chintang" # or Japanese
LEVEL="utterance_morphemes" # or utterance_morphemes

#This is the basic pipeline for acqdiv Chintang and Japanese.
#######################[2] COMPLETE
#create a result folder, with language and level subfolders, and a script folder
mkdir /scratch2/gloukatou/master_project/rerun/
ROOT="/scratch2/gloukatou/master_project/rerun" 

mkdir $ROOT/$LANGUAGE
mkdir $ROOT/$LANGUAGE/$LEVEL
 
INPUT_FILE="/scratch2/gloukatou/master_project/acqdiv_corpus_2017-09-28_CRJ.rda" #where the database is
RESULT_FOLDER="$ROOT/$LANGUAGE/$LEVEL" 
SCRIPT_FOLDER="/scratch2/gloukatou/CDSwordSeg/recipes/acqDiv" #where the scripts are

#[3] extract input from rda file, without children utterances and save at file extracted_raw.txt
Rscript $SCRIPT_FOLDER/sel_clean.r $INPUT_FILE $RESULT_FOLDER/extracted_raw.txt $LANGUAGE $LEVEL
grep -v -e "?" -e "NA"  $RESULT_FOLDER/extracted_raw.txt  > $RESULT_FOLDER/extracted_clean.txt #remove utterances with ? or NA

#[4]
#FOR CHINTANG ONLY, Nepali words have been extracted using script "sel_nepali_from_acqdiv.r" and saved as nepali_words.txt.
#FOR BOTH LANGUAGES, English words have to be removed.
sed -i -e 's/-//g' -e '/^\s*$/d' $RESULT_FOLDER/extracted_clean.txt

if [$LANGUAGE=="Chintang"]
then
 if [$LEVEL=="utterance"]
 then
 python2 $SCRIPT_FOLDER/remove_nepali.py $SCRIPT_FOLDER/nepali_words.txt $RESULT_FOLDER/extracted_clean.txt $RESULT_FOLDER/extracted_clean_nonepali.txt 
 python2 $SCRIPT_FOLDER/remove_nepali.py $SCRIPT_FOLDER/english_words.txt $RESULT_FOLDER/extracted_clean_nonepali.txt $RESULT_FOLDER/extracted_clean_nonepali1.txt
 else
 python2 $SCRIPT_FOLDER/remove_nepalim.py $SCRIPT_FOLDER/nepali_words.txt $RESULT_FOLDER/extracted_clean.txt $RESULT_FOLDER/extracted_clean_nonepali.txt
 python2 $SCRIPT_FOLDER/remove_nepalim.py $SCRIPT_FOLDER/english_words.txt $RESULT_FOLDER/extracted_clean_nonepali.txt $RESULT_FOLDER/extracted_clean_nonepali1.txt
 mv $RESULT_FOLDER/extracted_clean_nonepali1.txt $RESULT_FOLDER/extracted_clean1.txt 
 fi
else
 if [$LEVEL=="utterance"]
 then
 python2 $SCRIPT_FOLDER/remove_nepali.py $SCRIPT_FOLDER/english_words.txt $RESULT_FOLDER/extracted_clean.txt $RESULT_FOLDER/extracted_clean1.txt
 else
 python2 $SCRIPT_FOLDER/remove_nepalim.py $SCRIPT_FOLDER/english_words.txt $RESULT_FOLDER/extracted_clean.txt $RESULT_FOLDER/extracted_clean1.txt
 fi
fi

#[5] more cleaning
sed -i -e 's/^[ \t]*//g' -e '/^[ \t]*$/d' $RESULT_FOLDER/concatenate extracted_clean1.txt
bash $SCRIPT_FOLDER/cut.sh $RESULT_FOLDER $RESULT_FOLDER/concatenate extracted_clean1.txt divided_corpus.txt


#[6] 
for VERSION in $RESULT_FOLDER/concatenate/*
do
    if [ -d $VERSION ]
    then
        echo "$VERSION"

bash $SCRIPT_FOLDER/phonologize_newtags.sh $LANGUAGE $SCRIPT_FOLDER $VERSION

LANG=C
LC_CTYPE=C

#Precautionary measures
pcregrep --color='auto' -n '[^\x00-\x7F]' $VERSION/clean_corpus-gold.txt
#sed -i -e 's/[^\x00-\x7F]//g' -e 's/^\s//g' -e 's/^;esyll ;eword //g'  $VERSION/clean_corpus-gold.txt #no need to use, only precautionary
#sed -i -e 's/[^\x00-\x7F]//g' -e 's/^\s//g' -e 's/^;esyll ;eword //g'  $VERSION/clean_corpus-tags.txt #no need to use, only precautionary

#[10_a]

THISGOLD="$VERSION/clean_corpus-gold.txt"
THISTAG="${THISGOLD/gold/tags}"

mkdir $VERSION/results

source activate wordseg

cat $THISTAG | wordseg-prep -u syllable --gold /$VERSION/gold.txt > /$VERSION/prepared_syll.txt

cat $VERSION/prepared_syll.txt | wordseg-tp -t relative -p forward > $VERSION/results/segmented.ftp_rel.txt
cat $VERSION/results/segmented.ftp_rel.txt | wordseg-eval $VERSION/gold.txt > $VERSION/results/eval.ftp_rel.txt

cat $VERSION/prepared_syll.txt | wordseg-tp -t absolute -p forward > $VERSION/results/segmented.ftp_abs.txt
cat $VERSION/results/segmented.ftp_abs1.txt | wordseg-eval $VERSION/gold.txt > $VERSION/results/eval.ftp_abs.txt

cat $VERSION/prepared_syll.txt | wordseg-tp -t relative -p backward > $VERSION/results/segmented.btp_rel.txt
cat $VERSION/results/segmented.btp_rel.txt | wordseg-eval $VERSION/gold.txt > $VERSION/results/eval.btp_rel.txt#

cat $VERSION/prepared_syll.txt | wordseg-tp -t absolute -p backward > $VERSION/results/segmented.btp_abs.txt
cat $VERSION/results/segmented.btp_abs.txt | wordseg-eval $VERSION/gold.txt > $VERSION/results/eval.btp_abs.txt


size=$(wc -l <"$VERSION/results/prepared.txt")
echo "$size"

head -"${size}" $THISTAG > $VERSION/results/train.txt
head -200  $THISTAG > $VERSION/results/train200.txt

wordseg-dibs -t phrasal -o $VERSION/results/segmented.dibs.txt $VERSION/results/prepared.txt  $VERSION/results/train.txt
wordseg-eval -o $VERSION/results/eval.dibs.txt $VERSION/results/segmented.dibs.txt $VERSION/results/gold.txt

wordseg-dibs -t phrasal -o $VERSION/results/segmented.dibs200.txt $VERSION/results/prepared.txt  $VERSION/results/train200.txt
wordseg-eval -o $VERSION/results/eval.dibs200.txt $VERSION/results/segmented.dibs200.txt $VERSION/results/gold.txt


module load python-anaconda
wordseg-ag $VERSION/results/prepared.txt $SCRIPT_FOLDER/Colloc0_acqdiv.lt Colloc0 -n 2000 -vv > ${VERSION}/results/segmented.ag.txt
cat $VERSION/results/segmented.ag.txt | wordseg-eval $VERSION/results/gold.txt > $VERSION/results/eval.ag.txt


#PATH_TO_OLD_WORDSEG="/scratch2/gloukatou/CDSwordSeg"
#python $PATH_TO_OLD_WORDSEG/algoComp/segment_jap.py $THISTAG --goldfile $THISGOLD \
#       --output-dir $VERSION/results \
#       --algorithms dibs \
#       --verbose
#python $PATH_TO_OLD_WORDSEG/algoComp/segment_jap.py $THISTAG --goldfile $THISGOLD \
#	--output-dir $VERSION/results \
#       --algorithms AGu --ag-median 1 \
#       --verbose --sync

echo "done segmentation"

fi
done

bash $SCRIPT_FOLDER/collapse_results.sh $LANGUAGE $LEVEL $ROOT
cat $ROOT/merged*.csv >> $ROOT/merged_Chintang_Japanese.csv
sed -i -e 's/utterance_morphemes/morphemes/g' -e 's/utterance/words/g'  $ROOT/regression_Chintang_Japanese.csv
sed -i 1i"language,algorithm,level,fscore,subalgorithm,subcorpora" $ROOT/merged_Chintang_Japanese.csv

Rscript $SCRIPT_FOLDER/regression.r $ROOT/regression_Chintang_Japanese.csv $ROOT/plot.jpg > $ROOT/regression.txt

