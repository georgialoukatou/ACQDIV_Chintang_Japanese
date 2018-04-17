#!/bin/bash

# Loops through all the corpora and levels
# By Georgia Loukatou georgialoukatou@gmail.com
# Last changed Alex Cristia alecristia@gmail.com 2018-04-13

######################## USER, LOOK HERE
# file information
INPUT_FILE="/scratch2/gloukatou/master_project/acqdiv_corpus_2017-09-28_CRJ.rda" #where the database is
SCRIPT_FOLDER="/scratch1/users/acristia/acqdiv/ACQDIV_Chintang_Japanese/"  	#where the scripts are
ROOT="/scratch1/users/acristia/acqdiv/" 				#where you want results to be saved
N_PARTS=10 # number of subcorpora to use to be able to draw confidence intervals -- write in 1 if you want to analyze the full corpus (or if you're not rerunning the cleaning, phonologization and parsing,
SELECTION="full" # by default, this script analyzes the full database; you can also rerun it with the option "noforeign", in which case we recommend the N_PARTS to be 1
####################### USER, ALL DONE!

#------------ corpus preparation stage ------------#

# extract all ortho versions from rda file, without children utterances, clean and save both versions of the file (the full one, and the one without foreign words), inside the root folder // note R CMD BATCH works on both linux and unix, Rscript wasn't working on oberon
R CMD BATCH $SCRIPT_FOLDER/sel_clean.r $INPUT_FILE $ROOT

# phonologize ALL the files in the root folder
bash $SCRIPT_FOLDER/phonologize.sh $SCRIPT_FOLDER $ROOT

# cut the ensuing files into 10 subparts
if [ "$N_PARTS" -gt 1 ]
    for FILE in $ROOT/*/*/*-tags.txt ; do
    	bash $SCRIPT_FOLDER/cut.sh $FILE $N_PARTS
    done
fi


#------------ corpus analysis stage ------------#
module load python-anaconda
source activate wordseg

for LANGUAGE in Chintang Japanese ; do
    for LEVEL in morphemes words ; do

		#derive local vars
		RESULT_FOLDER="$ROOT/$LANGUAGE/$LEVEL" 

		#create a result folder, with language and level subfolders
		mkdir -p $RESULT_FOLDER

		./analyze.sh $SCRIPT_FOLDER $RESULT_FOLDER $N_PARTS $SELECTION
    done
done

source deactivate

#CHECK
#bash $SCRIPT_FOLDER/collapse_results.sh $LANGUAGE $LEVEL $ROOT
#cat $ROOT/merged*.csv >> $ROOT/merged_Chintang_Japanese.csv
#sed -i -e 's/utterance_morphemes/morphemes/g' -e 's/utterance/words/g'  $ROOT/regression_Chintang_Japanese.csv
#sed -i 1i"language,algorithm,level,fscore,subalgorithm,subcorpora" $ROOT/merged_Chintang_Japanese.csv

Rscript $SCRIPT_FOLDER/regression.r $ROOT/regression_Chintang_Japanese.csv $ROOT/plot.jpg > $ROOT/regression.txt

