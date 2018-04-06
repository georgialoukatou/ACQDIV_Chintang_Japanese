#!/usr/bin/env Rscript
args<-commandArgs(trailingOnly=TRUE)
acq<-load(args[1])
utterance_data<-data.frame(utterances)
clean_corpus<-utterance_data[ , c('language', args[4], 'speaker_label')]
language_data<-clean_corpus[clean_corpus$language==(args[3]) & clean_corpus$speaker_label!="DLCh1" & clean_corpus$speaker_label!="DLCh2" & clean_corpus$speaker_label!="DLCh3" & clean_corpus$speaker_label!="LDCh1" & clean_corpus$speaker_label!="LDCh2" & clean_corpus$speaker_label!="LDCh3" & clean_corpus$speaker_label!="LDCh4" & clean_corpus$speaker_label!="AKI" & clean_corpus$speaker_label!="ALS" & clean_corpus$speaker_label!="APR" & clean_corpus$speaker_label!="RYO" & clean_corpus$speaker_label!="TAI" & clean_corpus$speaker_label!="TOM" & clean_corpus$speaker_label!="ALJ" & clean_corpus$speaker_label!="ANJ" & clean_corpus$speaker_label!="JAS" & clean_corpus$speaker_label!="PAS" & clean_corpus$speaker_label!="VAN", ] # for Chintang and Japanese
#language_data<-clean_corpus[clean_corpus$language==(args[3]) & clean_corpus$speaker_label!="ALJ" & clean_corpus$speaker_label!="ANJ" & clean_corpus$speaker_label!="JAS" & clean_corpus$speaker_label!="PAS" & clean_corpus$speaker_label!="VAN", ] # for Russian
language_data_noCHI<-language_data[ ,2]
write.table(language_data_noCHI, file=args[2], row.names=F,col.names=F,quote=F)
