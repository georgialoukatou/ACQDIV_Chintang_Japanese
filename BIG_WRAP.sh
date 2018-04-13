#!/bin/bash

# Loops through all the corpora and levels
# By Georgia Loukatou georgialoukatou@gmail.com
# Last changed Alex Cristia alecristia@gmail.com 2018-04-13

########################[1] COMPLETE
# file information
INPUT_FILE="/scratch2/gloukatou/master_project/acqdiv_corpus_2017-09-28_CRJ.rda" #where the database is
SCRIPT_FOLDER="/scratch2/gloukatou/CDSwordSeg/recipes/acqDiv" 			#where the scripts are
ROOT="/scratch2/gloukatou/master_project/rerun" 				#where you want results to be saved
HYPERCLEAN="TRUE" # TRUE if you want to run the version without foreign words, FALSE otherwise
#######################

for LANGUAGE in Chintang Japanese ; do
	for LEVEL in utterance_morphemes utterance_words ; do
		./pipeline.sh $INPUT_FILE $SCRIPT_FOLDER $ROOT $HYPERCLEAN $LANGUAGE $LEVEL 
	done
done

#CHECK
#bash $SCRIPT_FOLDER/collapse_results.sh $LANGUAGE $LEVEL $ROOT
#cat $ROOT/merged*.csv >> $ROOT/merged_Chintang_Japanese.csv
#sed -i -e 's/utterance_morphemes/morphemes/g' -e 's/utterance/words/g'  $ROOT/regression_Chintang_Japanese.csv
#sed -i 1i"language,algorithm,level,fscore,subalgorithm,subcorpora" $ROOT/merged_Chintang_Japanese.csv

Rscript $SCRIPT_FOLDER/regression.r $ROOT/regression_Chintang_Japanese.csv $ROOT/plot.jpg > $ROOT/regression.txt

