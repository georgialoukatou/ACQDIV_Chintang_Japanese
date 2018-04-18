#!/bin/sh
# Wrapper to take a folder containing several cleaned up transcripts and phonologize them
# Alex Cristia alecristia@gmail.com 2015-10-26
# Modified by Laia Fibla laia.fibla.reixachs@gmail.com 2016-09-28 adapted to arg spanish
# Modified by Georgia Loukatou georgialoukatou@gmail.com 2017-04-02 adapted to chintang, japanese


#########VARIABLES
PATH_TO_SCRIPTS=$1
ROOT=$2	#this is the name of the input FOLDER
#########

LC_ALL=C

for ORTHO in $ROOT/*.txt ; do
	ROOT=$(dirname "$ORTHO")
	KEYNAME=$(basename "$ORTHO" .txt)

	#decompose keyname to get relevant info; example full_Chintang_morphemes.txt
	LANGUAGE=`echo $KEYNAME | cut -d "_" -f 2`
	LEVEL=`echo $KEYNAME | cut -d "_" -f 3 | sed "s/.txt//"`
	COVERAGE=`echo $KEYNAME | cut -d "_" -f 1`

	#derive local vars
	RESULT_FOLDER="$ROOT/$LANGUAGE/$LEVEL" 

echo processing $ORTHO into $RESULT_FOLDER

	#create a result folder, with language and level subfolders
	mkdir -p $RESULT_FOLDER


	if [ "$LANGUAGE" = "Japanese" ]
	   then
	  echo "recognized $LANGUAGE"
 tr '[:upper:]' '[:lower:]' < "$ORTHO"  | 
	  sed 's/ch/C/g' | 
	  sed 's/tt/T/g' | #double consonants
	  sed 's/kk/K/g' | #double consonants
	  sed 's/gg/G/g' | #double consonants
	  sed 's/ss/S/g' | #double consonants
	  sed 's/nn/N/g' | #double consonants
	  sed 's/pp/P/g' | #double consonants
	  sed 's/ʃ/J/g' |
	  sed 's/ŋ/n/g' |
	  sed 's/sy/W/g' | #y after consonant
	  sed 's/zy/Q/g' | #y after consonant
	  sed 's/ty/D/g' | #y after consonant
	  sed 's/ɽ/R/g' |
	  sed 's/ʒ/3/g' |
	  sed 's/え/X/g' |
	  sed 's/θ/V/g' |
	  sed 's/th/V/g' |
	  sed 's/my/M/g' | #y after consonant
	  sed 's/ry/R/g' | #y after consonant
	  sed 's/dy/9/g' | #y after consonant
	  sed 's/gy/B/g' | #y after consonant
	  sed 's/hy/F/g' | #y after consonant
	  sed 's/ny/L/g' | #y after consonant
	  sed 's/sh/Z/g' |
	  sed 's/aa/A/g' | #long a
	  sed 's/ii/I/g' | #long i
	  sed 's/ee/E/g' | #long e
	  sed 's/oo/O/g' | #long o
	  sed 's/uu/U/g' | #long u
	  sed 's/ai/7/g' | #no diphtongs in japanese
	  sed 's/oi/4/g' | #no	diphtongs in japanese
	  sed 's/au/5/g' | #no	diphtongs in japanese
	  sed 's/ɘ/1/g' |  
	  sed 's/o:/O/g' | #long o
	  sed 's/u:/U/g' | #long u
	  sed 's/e:/E/g' | #long e
	  sed 's/a:/A/g' | #long a
	  sed 's/i:/I/g' | #long i
	  sed 's/ei/E/g' | #ei is long e
	  sed 's/^\s//g' |
	  sed 's/si/Ji/g'| # no si
	  sed 's/ti/tJi/g' |
	  sed 's/tu/tsu/g' | #no tu, ti 
	  sed 's/wi/i/g' |
	  sed 's/wu/u/g' | #(w)i, (w)e, (w)o, (w)u
	  sed 's/we/e/g' |
	  sed 's/wo/o/g' |
	  sed 's/nja/La/g' |
	  sed 's/-/ /g' | 
	  tr -s "\'" ' '|
	  sed 's/ə/e/g' > $RESULT_FOLDER/${COVERAGE}_intoperl.tmp



	elif [ "$LANGUAGE" = "Chintang" ]
		 then
		echo "recognized $LANGUAGE"
	tr '[:upper:]' '[:lower:]'  < "$ORTHO"  |
		sed 's/jh/9/g' |#phoneme
		sed 's/̟c/c/g' |
		#sed 's/self /g' |
		#sed 's/ self/g'	|
		#sed 's/self/g' |
		sed 's/ɨ̵ŋ/1H/g' |
		sed 's/ǃ//g'  |
		sed 's/ɨ/1/g' | #valid vowel phoneme
		sed 's/̌à/a/g' |#no phonemic distinction
		sed 's/u̪/u/g'|#no phonemic distinction
		sed 's/eĩ/E/g' | #nasalized diphtongs actual phonemes
		sed 's/aĩ/A/g' | #nasalized diphtongs actual phonemes	
		sed 's/oĩ/O/g' | #nasalized diphtongs actual phonemes
		sed 's/uĩ/U/g' | #nasalized diphtongs actual phonemes
		sed 's/aũ/0/g' | #nasalized diphtongs actual phonemes
		sed 's/iĩ/I/g' | #nasalized diphtongs actual phonemes
		sed 's/[àãâāåà]/a/g' | #no length or other  distinctions for phonemes
		sed 's/ei/2/g' | #diphtongs actual phonemes
		sed 's/ai/3/g' | #diphtongs actual phonemes
		sed 's/oi/4/g' | #diphtongs actual phonemes
		sed 's/ui/5/g' | #diphtongs actual phonemes
		sed 's/au/6/g' | #diphtongs actual phonemes
		sed 's/1i/7/g' | #diphtongs actual phonemes
		sed 's/ñ/n/g' | #no phonemic distinction
		sed 's/[ā]/a/g' |#no phonemic distinction
		sed 's/[ũùûùü]/u/g' |#no phonemic distinction
		sed 's/[ôò]/o/g' |#no phonemic distinction
		sed 's/[èẽë]/e/g' |#no phonemic distinction
		sed 's/[ĩīĩ]/i/g' |#no phonemic distinction
		sed 's/kk/K/g' |#gemination
		sed 's/tt/T/g' |#gemination	
		sed 's/cc/C/g' |#gemination
		sed 's/bb/B/g' |#gemination
		sed 's/ss/S/g' |#gemination
		sed 's/nn/N/g' |#gemination
		sed 's/ñ/n/g' |#no phonemic distinction
		sed 's/mm/M/g' |#gemination
		sed 's/jj/J/g' |#gemination
		sed 's/lh/L/g' |#phoneme
		sed 's/gh/G/g' |#phoneme
		sed 's/pp/P/g' |#gemination
		sed 's/dh/D/g' |#phoneme
		sed 's/ḍ/d/g' |#no phonemic distinction
		sed 's/ch/Y/g' |#phoneme
		sed 's/jh/Ζ/g' |#phoneme
		sed 's/bh/V/g' | #phoneme
		sed 's/kh/Q/g' |#phoneme
		sed 's/th/X/g' |#phoneme
		sed 's/ʔ/q/g' |#phoneme
		sed 's/ṽ/v/g' |#no phonemic distinction
		sed 's/ŋ/H/g' |#phoneme
		sed 's/�//g' |
		sed 's/m̄/m/g' |#no phonemic distinction
		sed 's//e/g' |
		sed 's/Ḧ//g' |
		sed 's/Ë/e/g' |
		sed 's/ɲ/n/g' |#no phonemic distinction
		sed 's/hAA̴/ha/g' |
		sed 's/ptn/pn/g' | # second consonant dropped if cluster of three, ptn
		sed 's/¨//g'  |# georgia please document this line and the following -- if this is cleaning of illegal chars, it should happen in the R file
		sed 's/Œ ñ//g' |
		sed 's/Œ £//g' |
		sed 's/‡ • §//g' |
		sed 's/̵//g'  |
		sed 's/̪//g'  |
		sed 's/~//g'  |
		sed 's/ʌ//g'  |
		sed 's/˜//g'  |
		sed 's/।//g'  |
		sed 's/̴̴//g'  |
		sed 's/̴//g'  |
		sed 's/±//g'  |
		sed 's/lUɡE//g' |  # georgia please document this line and all of the following, as they seem arbitrary
		sed 's/IɡIMA//g' |
		sed 's/iɡiMa//g' |
		sed 's/hu̪i/hui/g' |
		sed 's/hãǃ/ha/g' |
		sed 's/ɨ̵ŋ/1H/g' |
		sed 's/luɡe//g' |
		sed 's/ph/F/g' > $RESULT_FOLDER/${COVERAGE}_intoperl.tmp


	fi


		echo "syllabify-corpus.pl"
		perl $PATH_TO_SCRIPTS/syllabify-corpus.pl $LANGUAGE $RESULT_FOLDER/${COVERAGE}_intoperl.tmp $RESULT_FOLDER/${COVERAGE}_outofperl.tmp $PATH_TO_SCRIPTS


		echo "removing blank lines"
		LANG=C LC_CTYPE=C LC_ALL=C
		cat $RESULT_FOLDER/${COVERAGE}_outofperl.tmp | 
		sed 's/ / ;word /g' | #replace word boundaries with our word tag
		sed 's/^\///g' | #remove sentence-initial syll boundaries
		sed 's/\// ;esyll /g' | #replace syll boundaries with our syll tag
		sed 's/^[ ]*//g'  | # delete sentence-initial blanks
		sed 's/[ ]*$//g' | # delete sentence-final blanks
		sed '/^$/d' | # delete empty lines
#		sed 's/।//g' | # georgia please correct this line and all of the following
#		sed 's/�//g' |
#		sed 's/«a/a/g' |
#		sed 's/å/a/g' |
# 		sed 's/‡//g' |
# 		sed 's/§//g' |
#		sed 's/™//g' |
#		sed 's/ü//g' |
#		sed 's/a?//g' |
		sed '/^[ ]*$/d' > $RESULT_FOLDER/tmp.tmp # delete blank lines
			 
	
		mv $RESULT_FOLDER/tmp.tmp ${RESULT_FOLDER}/${COVERAGE}-tags.txt


done



echo "end"

