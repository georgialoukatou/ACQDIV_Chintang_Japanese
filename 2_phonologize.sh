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
	  sed 's/ŋ/n/g' | # GEORGIA PLEASE CHECK -- ISN'T THIS THE MORAIC NASAL, THAT TAKES THE PLACE OF ARTICULATION OF THE NEXT C
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
	  sed 's/si/Ji/g'| # no si
	  sed 's/ti/tJi/g' |
	  sed 's/tu/tsu/g' | #no tu, ti 
	  sed 's/wi/i/g' | #(w)i, (w)e, (w)o, (w)u
	  sed 's/wu/u/g' | 
	  sed 's/we/e/g' |
	  sed 's/wo/o/g' |
	  sed 's/nja/La/g' | #Georgia please explain this one
	  sed 's/ə/e/g' > $RESULT_FOLDER/${COVERAGE}_intoperl.tmp



	elif [ "$LANGUAGE" = "Chintang" ]
		 then
		echo "recognized $LANGUAGE"
	tr '[:upper:]' '[:lower:]'  < "$ORTHO"  |
		sed 's/jh/9/g' |#phoneme
		sed 's/̟c/c/g' |#no phonemic distinction+diacritic issue
 		sed 's/ŋ ̟t/Ht/g' | # idem
		sed 's/a ̟k/ak/g' | # idem
		sed 's/eĩ/E/g' | #nasalized diphtongs actual phonemes
		sed 's/aĩ/A/g' | #nasalized diphtongs actual phonemes	
		sed 's/oĩ/O/g' | #nasalized diphtongs actual phonemes
		sed 's/uĩ/U/g' | #nasalized diphtongs actual phonemes
		sed 's/aũ/0/g' | #nasalized diphtongs actual phonemes
		sed 's/iĩ/I/g' | #nasalized diphtongs actual phonemes
		sed 's/ei/2/g' | #diphtongs actual phonemes
		sed 's/ai/3/g' | #diphtongs actual phonemes
		sed 's/oi/4/g' | #diphtongs actual phonemes
		sed 's/ui/5/g' | #diphtongs actual phonemes
		sed 's/au/6/g' | #diphtongs actual phonemes
		sed 's/1i/7/g' | #diphtongs actual phonemes
		sed 's/[ãààãâāåaaååå̀ã]/a/g' | #no length or other  distinctions for phonemes
		sed 's/[ôò]/o/g' |#no phonemic distinction
		sed 's/[èẽëË]/e/g' |#no phonemic distinction
		sed 's/ɨ/1/g' | #valid vowel phoneme
		sed 's/[ĩīĩ]/i/g' |#no phonemic distinction
		sed 's/[u̪uüuu̪u̪]/u/g' |#no phonemic distinction
		sed 's/kk/K/g' |#gemination
		sed 's/tt/T/g' |#gemination	
		sed 's/cc/C/g' |#gemination
		sed 's/bb/B/g' |#gemination
		sed 's/ss/S/g' |#gemination
		sed 's/nn/N/g' |#gemination
		sed 's/[ñɲ]/n/g' |#no phonemic distinction
		sed 's/ŋ/H/g' |#phoneme
		sed 's/[m̄m]/m/g' |#no phonemic distinction
		sed 's/mm/M/g' |#gemination
		sed 's/jj/J/g' |#gemination
		sed 's/lh/L/g' |#phoneme
		sed 's/gh/G/g' |#phoneme
		sed 's/pp/P/g' |#gemination
		sed 's/dh/D/g' |#phoneme
		sed 's/[ḍd]/d/g' |#no phonemic distinction
		sed 's/ch/Y/g' |#phoneme
		sed 's/jh/Ζ/g' |#phoneme
		sed 's/bh/V/g' | #phoneme
		sed 's/kh/Q/g' |#phoneme
		sed 's/th/X/g' |#phoneme
		sed 's/ph/F/g' |
		sed 's/ʔ/q/g' |#phoneme
		sed 's/[ṽv]/v/g' |#no phonemic distinction
		sed 's/ptn/pn/g' | # second consonant dropped if cluster of three, ptn
		sed 's/[ɡg]/g/g' |# no phonemic distinction
		sed 's/̵//g'  |# these are necessary in case these diacritics escaped rules above; they cannot be done in the cleaning stage because they might distinguish sounds
		sed 's/̪//g'  |
		sed 's/~//g'  |
               sed 's/̟ ̟//g' | 
		sed 's/¨//g'  |
		sed 's/˜//g'  |
		sed 's/̴̴//g'  |
		sed 's/̴//g'   > $RESULT_FOLDER/${COVERAGE}_intoperl.tmp

	fi


		echo "perl $PATH_TO_SCRIPTS/syllabify-corpus.pl $LANGUAGE $RESULT_FOLDER/${COVERAGE}_intoperl.tmp $RESULT_FOLDER/${COVERAGE}_outofperl.tmp $PATH_TO_SCRIPTS"
		perl $PATH_TO_SCRIPTS/syllabify-corpus.pl $LANGUAGE $RESULT_FOLDER/${COVERAGE}_intoperl.tmp $RESULT_FOLDER/${COVERAGE}_outofperl.tmp $PATH_TO_SCRIPTS


		echo "removing blank lines"
		LANG=C LC_CTYPE=C LC_ALL=C
		cat $RESULT_FOLDER/${COVERAGE}_outofperl.tmp | 
                sed 's/^[ ]*//g'  | # delete sentence-initial blanks
                sed 's/[ ]*$//g' | # delete sentence-final blanks
                tr -s " " | #single spaces
                tr " " ":" | #replace spaces with intermediate symbol for word boundary
                sed 's/$/:/g' | #make sure each sentence ends with a word boundary ...
                tr -s ":" | #... but only one of them
                sed 's/\(.\)/\1 /g' | #insert spaces between every two letters
                tr -s " " | #single spaces
                sed 's/:/ ;eword /g' | #replace word boundaries with our word tag
                sed 's/ ;eword[ ]*$/ ;eword \//g' | #add syllable break final word break
                sed 's/^\///g' | #remove sentence-initial syll boundaries
                sed 's/\// ;esyll /g' | #replace syll boundaries with our syll tag
                sed 's/;eword[ ]*;esyll/;esyll ;eword/g' | #invert syll and word boundaries
                tr -s " " | #single spaces
                sed 's/^[ ]*//g'  | # delete sentence-initial blanks
                sed 's/[ ]*$//g' | # delete sentence-final blanks
                sed '/^$/d' | # delete empty lines
		sed '/^[ ]*$/d' > $RESULT_FOLDER/tmp.tmp # delete blank lines
			 
	
		mv $RESULT_FOLDER/tmp.tmp ${RESULT_FOLDER}/${COVERAGE}-tags.txt


done



echo "end"
