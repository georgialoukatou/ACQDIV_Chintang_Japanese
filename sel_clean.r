#!/usr/bin/env Rscript

# Loops through all the corpora and levels
# By Georgia Loukatou georgialoukatou@gmail.com
# Last changed Alex Cristia alecristia@gmail.com 2018-04-13
# sample call Rscript sel_clean.r $INPUT_FILE $RESULT_FOLDER/

# get arguments passed by user
args<-commandArgs(trailingOnly=TRUE)
INPUT_FILE=args[1]
RESULT_FOLDER=args[2]

# local use
# INPUT_FILE="acqdiv_corpus_2017-09-28_CRJ.rda"


######## CLEANING FUNCTIONS
clean<-function(corpus){
  corpus[,selcol]=as.character(corpus[,selcol])
  corpus[grep("?",corpus[,selcol],invert=T,fixed=T),]->corpus #remove sentences with untranscribed material

  # remove illegal characters
  illegalchars=c("^","'","(",")","&","?",".",",","-","=","…","!","_",":","/","-")
  for(thiscar in illegalchars) corpus[,selcol]<-gsub(thiscar,"",corpus[,selcol],fixed=T)

  #"DELAY" appears throughout Chintang morphemes_utt; comparison between the morpheme and the utterance database suggests this is a human code --> remove before phonologization
  gsub("DELAY","",corpus[,selcol],fixed=T)->corpus[,selcol]
  
  #remove trailing, initial, or double spaces
  corpus[,selcol]<-gsub("^ ", "", corpus[,selcol])
  corpus[,selcol]<-gsub(" $", "", corpus[,selcol])
  corpus[,selcol]<-gsub("[ ]* ", " ", corpus[,selcol])
  
  # some Japanese utterances contain only one consonant (ie the sentence is one consonant)
  gsub("^[bcdfghjklmnpqrstvwxz]$","",corpus[,selcol])->corpus[,selcol]

    #final clean up
  corpus[!is.na(corpus[,selcol]),]->corpus
  corpus[corpus[,selcol]!="",]->corpus
  corpus
}


########

#real processing begins -- load file
acq<-load(INPUT_FILE)

#get morpheme data to generate dataframes with and without foreign words
morpheme_data<-data.frame(words)
morpheme_data$unique=as.factor(paste(morpheme_data$corpus, morpheme_data$session_id_fk,morpheme_data$utterance_id_fk))

#get utterance-based data
utterance_data<-data.frame(utterances)
utterance_data$unique=paste(utterance_data$corpus, utterance_data$session_id_fk,utterance_data$utterance_id) #note col name for utt id is different

#remove children -- NOTE: THIS COULD BE DANGEROUS IF  A NON-CHILD HAS THE NAME OF A CHILD IN ANOTHER CORPUS
excluded=c("DLCh1","DLCh","DLCh3",
           "LDCh1","LDCh2","LDCh3","LDCh4",
           "AKI","ALS" ,"APR" ,"RYO" ,"TAI","TOM" ,
           "ALJ" ,"ANJ" ,"JAS" ,"PAS" ,"VAN")

for(LANGUAGE in c("Chintang","Japanese")){
  for(LEVEL in c("words","morphemes")){
    # LANGUAGE="Chintang"
    # LEVEL="morphemes"
    
    if(LEVEL == "words") selcol <-"utterance" else if(LEVEL=="morphemes") selcol<-"utterance_morphemes" else print("BAD LEVEL")

    #get codes for all utts in this corpus
    levels(factor(morpheme_data[morpheme_data$language==LANGUAGE, "unique"]))->corpus_utts
    
    #get codes for only utts in this corpus that do NOT contain codes for foreign languages
    levels(morpheme_data$word_language)->all_lang
    all_lang[grep(LANGUAGE,all_lang,invert=T)]->bad_lang #get all the language tags that do not include our key language
    levels(factor(morpheme_data[morpheme_data$word_language %in% bad_lang,"unique"]))->exclude_utts #get the utts that do have foreign words
    native_utts<-corpus_utts[!(corpus_utts %in% exclude_utts)] #get the opposite subset
    
    #subset to utterances of the language under study + remove utterances by children
    sel_utts<-utterance_data[ utterance_data$language==LANGUAGE & !(utterance_data$speaker_label %in% excluded), 
                                  c('unique', selcol)]
    print(dim(sel_utts))
    clean_corpus<-clean(sel_utts)
    print(dim(clean_corpus))
    
    write.table(clean_corpus[   ,selcol] , 
                file=paste0(RESULT_FOLDER,"/full_",LANGUAGE,"_",LEVEL,".txt"), 
                row.names=F,col.names=F,quote=F)
    
    write.table(clean_corpus[clean_corpus$unique %in% native_utts,selcol] , 
                file=paste0(RESULT_FOLDER,"/noforeign_",LANGUAGE,"_",LEVEL,".txt"),  
                row.names=F,col.names=F,quote=F)
    
  }
}

