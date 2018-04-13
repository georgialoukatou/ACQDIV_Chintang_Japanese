#!/usr/bin/env Rscript

# Loops through all the corpora and levels
# By Georgia Loukatou georgialoukatou@gmail.com
# Last changed Alex Cristia alecristia@gmail.com 2018-04-13
# sample call Rscript sel_clean.r $INPUT_FILE $RESULT_FOLDER/extracted_raw.txt $LANGUAGE $LEVEL

args<-commandArgs(trailingOnly=TRUE)
INPUT_FILE=args[1]
RESULT_FOLDER=args[2]
LANGUAGE=args[3]
LEVEL=args[4]
if(LEVEL == "words") selcol <-"utterance" else if(LEVEL=="morphemes") selcol<-"utterance_morphemes" else print("BAD LEVEL")

acq<-load(INPUT_FILE)

#get morpheme data to generate dataframes with and without foreign words
morpheme_data<-data.frame(words)
morpheme_data$unique=as.factor(paste(morpheme_data$corpus, morpheme_data$session_id_fk,morpheme_data$utterance_id_fk))

#all utts in this corpus
levels(factor(morpheme_data[morpheme_data$language==LANGUAGE, "unique"]))->corpus_utts

#only utts in this corpus that do NOT contain codes for foreign languages
levels(morpheme_data$word_language)->all_lang
all_lang[grep(LANGUAGE,all_lang,invert=T)]->bad_lang #get all the language tags that do not include our key language
levels(factor(morpheme_data[morpheme_data$word_language %in% bad_lang,"unique"]))->exclude_utts #get the utts that do have foreign words
native_utts<-corpus_utts[!(corpus_utts %in% exclude_utts)] #get the opposite subset


#get utterances
utterance_data<-data.frame(utterances)
utterance_data$unique=paste(utterance_data$corpus, utterance_data$session_id_fk,utterance_data$utterance_id) #note col name for utt id is different

#remove children
excluded=c("DLCh1","DLCh","DLCh3",
           "LDCh1","LDCh2","LDCh3","LDCh4",
           "AKI","ALS" ,"APR" ,"RYO" ,"TAI","TOM" ,
           "ALJ" ,"ANJ" ,"JAS" ,"PAS" ,"VAN")
clean_corpus<-utterance_data[ utterance_data$language==LANGUAGE & !(utterance_data$speaker_label %in% excluded), 
                              c('unique', selcol)]

# remove utterances with illegal markers, replace some characters
clean_corpus[grep("?",clean_corpus[,selcol],invert=T,fixed=T),]->clean_corpus
clean_corpus[,selcol]<-gsub("  "," ",clean_corpus[,selcol])
clean_corpus[,selcol]<-gsub("-","",clean_corpus[,selcol])
clean_corpus[,selcol]<-gsub("\t","",clean_corpus[,selcol])
clean_corpus[!is.na(clean_corpus[,selcol]),]->clean_corpus
clean_corpus[clean_corpus[,selcol]!="",]->clean_corpus

write.table(clean_corpus[   ,selcol] , file=paste0(RESULT_FOLDER,"/full_",LANGUAGE,"_",LEVEL,".txt"), row.names=F,col.names=F,quote=F)

write.table(clean_corpus[clean_corpus$unique %in% native_utts,selcol] , file=paste0(RESULT_FOLDER,"/
	noforeign_",LANGUAGE,"_",LEVEL,".txt"),  row.names=F,col.names=F,quote=F)


