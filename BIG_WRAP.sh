#!/bin/bash

# Loops through all the corpora and levels
# By Georgia Loukatou georgialoukatou@gmail.com
# Last changed Alex Cristia alecristia@gmail.com 2018-04-13

######################## USER, LOOK HERE
# file information
#INPUT_FILE="/Users/acristia/Documents/acqdiv/acqdiv_corpus_2017-09-28_CRJ.rda" #where the database is
SCRIPT_FOLDER="/scratch1/users/acristia/acqdiv/ACQDIV_Chintang_Japanese" #where the scripts are
ROOT="/scratch1/users/acristia/acqdiv/" #where you want results to be saved
SELECTION="full" # by default, this script analyzes the full database; you can also rerun it with the option "noforeign", in which case we recommend the N_PARTS to be 5
N_PARTS=10 # number of subcorpora to use to be able to draw confidence intervals
####################### USER, ALL DONE!

#------------ corpus preparation stage ------------#

# extract all ortho versions from rda file, without children utterances, clean and save both versions of the file (the full one, and the one without foreign words), inside the root folder 
# NOTE !!! Rscript not working on oberon
#RScript $SCRIPT_FOLDER/sel_clean.r $INPUT_FILE $ROOT

# phonologize ALL the files in the root folder
# bash $SCRIPT_FOLDER/phonologize.sh $SCRIPT_FOLDER $ROOT

# cut the ensuing files into N_PARTS subparts
if [ "$N_PARTS" -gt 1 ] ; then
    for FILE in $ROOT/*/*/*-tags.txt ; do
    	bash $SCRIPT_FOLDER/cut.sh $FILE $N_PARTS
    done
fi


#------------ corpus analysis stage ------------#
module load python-anaconda
source activate /cm/shared/apps/python-anaconda/envs/wordseg

for LANGUAGE in Chintang  ; do
    for LEVEL in morphemes ; do

		#derive local vars
		RESULT_FOLDER="$ROOT/$LANGUAGE/$LEVEL" 

#		bash $SCRIPT_FOLDER/analyze.sh $SCRIPT_FOLDER $RESULT_FOLDER $N_PARTS $SELECTION

#		bash $SCRIPT_FOLDER/collapse_results.sh $RESULT_FOLDER/$SELECTION
    done
done

source deactivate


#CHECK
#bash $SCRIPT_FOLDER/collapse_results.sh $LANGUAGE $LEVEL $ROOT
#cat $ROOT/merged*.csv >> $ROOT/merged_Chintang_Japanese.csv
#sed -i -e 's/utterance_morphemes/morphemes/g' -e 's/utterance/words/g'  $ROOT/regression_Chintang_Japanese.csv
#sed -i 1i"language,algorithm,level,fscore,subalgorithm,subcorpora" $ROOT/merged_Chintang_Japanese.csv

#Rscript $SCRIPT_FOLDER/regression.r $ROOT/regression_Chintang_Japanese.csv $ROOT/plot.jpg > $ROOT/regression.txt

