#!/usr/bin/env Rscript
acq<-load("/Users/lscpuser/Documents/acqdiv_corpus_2017-09-28_CRJ.rda")  ##complete with path to database 

morpheme_data<-data.frame(words)
clean_corpus<-morpheme_data[ , c('word_language', "word")]
language_data<-clean_corpus[clean_corpus$word_language=="English", ] ## or Nepali, both have been removed
list.var<-unique(language_data$word)
options(max.print=70000)

sink("/Users/lscpuser/Desktop/ch_english.txt") ## complete with path to output
print(list.var)
sink()