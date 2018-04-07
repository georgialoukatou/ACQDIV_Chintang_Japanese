#!/bin/sh
# Wrapper to take a single cleaned up transcript and phonologize it
# Alex Cristia alecristia@gmail.com 2015-10-26
# Modified by Laia Fibla laia.fibla.reixachs@gmail.com 2016-09-28 adapted to arg spanish
# Modified by Georgia Loukatou georgialoukatou@gmail.com 2017-04-02 adapted to chintang, japanese


#########VARIABLES
#Variables to modify
LANGUAGE=$1


PATH_TO_SCRIPTS=$2
#path to the phonologization folder - E.g. PATH_TO_SCRIPTS="/home/xcao/cao/projects/ANR_Alex/CDSwordSeg/phonologization/"

RES_FOLDER=$3
#this is where we will put the processed versions of the transcripts E.g. RES_FOLDER="/home/xcao/cao/projects/ANR_Alex/res_Childes_Eng-NA_cds/"
# NOTICE THE / AT THE END OF THE NAME

LC_ALL=C

for ORTHO in ${RES_FOLDER}/divided_corpus.txt; do
	KEYNAME=$(basename "$ORTHO" .txt)
	if [ "$LANGUAGE" = "Japanese" ]
	   then
	  echo "recognized $LANGUAGE"
 tr '[:upper:]' '[:lower:]' < "$ORTHO"  | 
	  sed 's/ $//g' | #
	  sed 's/^$//g' | #
	  sed 's/_pres//g'|
          sed 's/_imp//g'|
          sed 's/_adv//g'|
          sed 's/_sger//g'|
          sed 's/_beg//g'|
          sed 's/_pol//g'|
          sed 's/_conn//g'|
          sed 's/_past//g'|
          sed 's/_cond//g'|
          sed 's/_pass//g' |
          sed 's/_quot//g'|
          sed 's/_caus//g'|
          sed 's/&pres//g' |
          sed 's/&pre//g' |
          sed 's/&imp//g'|
          sed 's/&adv//g'|
          sed 's/&sger//g'|
          sed 's/&neg//g' |
          sed  's/&pol//g' |
          sed 's/&conn//g' |
          sed 's/&past//g'|
          sed 's/&cond//g'|
          sed 's/&pass//g' |
          sed 's/&quot//g' |
    	  sed 's/&caus//g' |
          sed 's/NA//g' |
	  sed 's/^[bcdfghjklmnpqrstvwxz]$//g' |
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
	  sed 's/ə/e/g' > $RES_FOLDER/intoperl.tmp

	  echo "syllabify-corpus.pl"
	  perl $PATH_TO_SCRIPTS/new-syllabify-corpus.pl $LANGUAGE $RES_FOLDER/intoperl.tmp $RES_FOLDER/outofperl.tmp $PATH_TO_SCRIPTS


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
		sed 's/¨//g'  |
		sed 's/Œ ñ//g' |
		sed 's/Œ £//g' |
		sed 's/‡ • §//g' |
		sed 's/̵//g'  |
		sed 's/̪//g'  |
		sed 's/~//g'  |
		sed 's/ʌ//g'  |
		sed 's/˜//g'  |
		#sed 's/\'//g' |
		sed 's/।//g'  |
		sed 's/̴̴//g'  |
		#sed 's/"//g'  |
		sed 's/̴//g'  |
		sed 's/±//g'  |
		sed 's/lUɡE//g' |
		sed 's/IɡIMA//g' |
		sed 's/iɡiMa//g' |
		sed 's/hu̪i/hui/g' |
		sed 's/hãǃ/ha/g' |
		sed 's/ɨ̵ŋ/1H/g' |
		sed 's/luɡe//g' |
		#sed 's/&//g' |
		#sed '/^[ \t]*$/d' |
                sed '/^ $/d'  |
                sed '/^$/d' |
		sed 's/^ //g' |
		sed 's/ptn/pn/g' | # second consonant droped if cluster of three, ptn
		sed 's/ph/F/g' > $RES_FOLDER/intoperl.tmp

		echo "syllabify-corpus.pl"
		perl $PATH_TO_SCRIPTS/new-syllabify-corpus.pl $LANGUAGE $RES_FOLDER/intoperl.tmp $RES_FOLDER/outofperl.tmp $PATH_TO_SCRIPTS

	fi

		echo "removing blank lines"
		LANG=C LC_CTYPE=C LC_ALL=C
		sed '/^$/d' $RES_FOLDER/outofperl.tmp |
		sed 's/_pres//g'|
		sed 's/_imp//g'|
		sed 's/_adv//g'| 
		sed 's/_sger//g'|
		sed 's/_neg//g'|
		sed 's/_pol//g'|
		sed 's/_conn//g'|
		sed 's/_past//g'|
		sed 's/_cond//g'|
		sed 's/_pass//g' |
		sed 's/_quot//g'| 
		sed 's/_caus//g'| 
		sed 's/&pres//g' |
		sed 's/&pre//g' |
		sed 's/&imp//g'| 
		sed 's/&adv//g'|
		sed 's/&sger//g'| 
		sed 's/&neg//g' |
		sed 's/&pol//g' | 
		sed 's/&conn//g' |
		sed 's/&past//g'|
		sed 's/&cond//g'|
		sed 's/&pass//g' | 
		sed 's/&quot//g' |
		sed 's/&caus//g' | 
		sed 's/NA//g' |
		sed 's/\^//g' | 
		sed "s/\'//g" |
		sed 's/)//g' |
		sed 's/(//g' |
		sed 's/&//g' | 
		sed '/^ $/d'  |
		sed '/^$/d' |
		sed 's/।//g' |
		sed '/^[ ]*$/d'  |
		sed 's/^ //g'  |
		sed 's/^  //g' |		
		sed 's/^ //g'  |
		sed 's/^\s//g'  |		
		sed 's/?//g' |
		sed 's/�//g' |
		sed 's/\n//g' |
		sed 's/^//g' |
		sed 's/«a/a/g' |
		sed 's/å/a/g' |
		sed 's/\.//g' |
 		sed 's/\,//g' |
 		sed 's/̌//g' |
 		sed 's/‡//g' |
 		sed 's/§//g' |
 		sed 's/̟//g' |
		sed 's/?//g' |
		sed 's/^//g' |
		sed 's/=//g' |
		sed 's/-//g' |
		sed 's/™//g' |
		#sed 's/'//g' |
		sed 's/ü//g' |
		sed 's/  / /g' |
		sed 's/…//g' |
		sed 's/\!//g' |
		sed 's/_//g' |
		#sed 's/\'//g' |		
		sed 's/://g' |
		sed 's/a?//g' |
		sed 's/^\s//g' |
		sed 's/^\///g'  | #there aren't really any of these, this is just a cautionary measure	
		sed 's/  / /g'|
		sed 's/  / /g'|		
		sed 's/^\s//g' |
		sed 's/ \//\/ \//g'|
		sed 's/ $/\/ /g' |
		#sed 's/^\///g' |
		sed 's/^[ \t]*//g' |
		sed 's/^ //g' |
		sed 's/^\s//g'  |
               sed 's/^[[:space:]]//g'	|	
                sed 's/ /;eword/g' |
		sed 's/\//;esyll/g'|		
		sed 's/;esyll ;esyll/;esyll/g' |
		##sed 's/ /;eword/g' |
		##sed -e 's/\(.\)/\1 /g'  |
		sed 's/; e w o r d/ ;eword /g' |
		sed 's/; e s y l l/ ;esyll /g'|
		##sed 's/\// ;esyll /g'|
		sed 's/;eword $/;esyll ;eword$/g'|
		sed 's/  / /g'|
		sed 's/;eword ;esyll/;esyll ;eword/g'|
		sed 's/;esyll ;eword ;esyll/;esyll ;eword/g' |
		tr -s ' '  |
		sed 's/;esyll ;eword ;esyll/;esyll ;eword/g' |
		sed 's/^;esyll ;eword//g' | 
		sed 's/^ ;esyll ;eword//g' |
		sed 's/^  ;esyll ;eword//g' | 
		sed 's/^ //g' |		
		sed 's/^;esyll ;eword//g' > $RES_FOLDER/tmp.tmp
	
		mv $RES_FOLDER/tmp.tmp ${RES_FOLDER}/clean_corpus-tags.txt

	echo "creating gold versions"

		sed -e 's/;esyll//g' -e 's/?//g' < ${RES_FOLDER}/clean_corpus-tags.txt |
		tr -d ' ' |
		sed -e's/;eword/ /g'  -e 's/?//g' > ${RES_FOLDER}/clean_corpus-gold.txt


done



echo "end"

##pcregrep --color='auto' -n '[^\x00-\x7F]' $PROCESSED_FILE2
sed -i 's/^ //g' ${RES_FOLDER}/clean_corpus-gold.txt
sed -i 's/^;esyll;esyll;eword;esyl//g' ${RES_FOLDER}/clean_corpus-tags.txt
sed -i 's/^;esyll;esyll;eword;//g' ${RES_FOLDER}/clean_corpus-tags.txt
sed -i 's/^$//g' ${RES_FOLDER}/clean_corpus-gold.txt
sed -i 's/^;esyll;esyll;eword//g' ${RES_FOLDER}/clean_corpus-tags.txt
