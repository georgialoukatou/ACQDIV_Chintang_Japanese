#!/usr/bin/env Rscript

# Loops through all the corpora and levels
# By Georgia Loukatou georgialoukatou@gmail.com
# Last changed Alex Cristia alecristia@gmail.com 2018-04-13

# get arguments passed by user
args<-commandArgs(TRUE)

INPUT_FILE<-args[1]
RESULT_FOLDER<-args[2]
# local use
# INPUT_FILE="/Users/acristia/Documents/acqdiv/acqdiv_corpus_2017-09-28_CRJ.rda"
# RESULT_FOLDER="/Users/acristia/Documents/acqdiv/"

sink("record_clean.txt")

print(INPUT_FILE)
print(RESULT_FOLDER)


######## CLEANING FUNCTIONS
clean<-function(corpus,toremove,selcol,LANGUAGE,LEVEL){
  #utterance_data -> corpus
  corpus[,selcol]=as.character(corpus[,selcol])

  ##### special cleaning ####
  #"DELAY" appears throughout Chintang morphemes_utt; comparison between the morpheme and the utterance database suggests this is a human code --> remove before phonologization
  if(LANGUAGE=="Chintang" & LEVEL=="morphemes") gsub("DELAY","",corpus[,selcol],fixed=T)->corpus[,selcol]
    #"-laugh" appears 1x Japanese utt; comparison between the morpheme and the utterance database suggests this is a human code --> remove before phonologization
  if(LANGUAGE=="Japanese" & LEVEL=="words") gsub("-laugh","",corpus[,selcol],fixed=T)->corpus[,selcol]
  #lots of codes in Japanese morph; comparison between the morpheme and the utterance database suggests this is a human code --> remove before phonologization
  if(LANGUAGE=="Japanese" & LEVEL=="morphemes"){
    illegalchars=c("&ADV","&CAUS","&COND","&CONN","&NEG","&IMP","&PAST","&POL","&PRES","&QUOT","&SGER","-HON","_NEG")
    for(thiscar in illegalchars) corpus[,selcol]<-gsub(thiscar,"",corpus[,selcol],fixed=T)
  } 
  
    if(LANGUAGE=="Japanese" & LEVEL=="morphemes"){
      for(thissep in c("-","_","=","&",".")) corpus[,selcol]<-gsub(thissep," ",corpus[,selcol],fixed=T)
     }
  if(LANGUAGE=="Japanese" & LEVEL=="words"){
    corpus[,selcol]<-gsub("_"," ",corpus[,selcol],fixed=T)
  }
  ##### regular cleaning ####
  # remove illegal characters passed by user
  for(thiscar in toremove) corpus[,selcol]<-gsub(thiscar,"",corpus[,selcol],fixed=T)

  #remove trailing, initial, or double spaces
  corpus[,selcol]<-gsub("^ ", "", corpus[,selcol])
  corpus[,selcol]<-gsub(" $", "", corpus[,selcol])
  corpus[,selcol]<-gsub("[ ]* ", " ", corpus[,selcol])
  
  #remove empty utterances
  corpus[corpus[,selcol]!="",]->corpus

  #return
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
utterance_data[!(utterance_data$speaker_label %in% excluded),]->utterance_data

print("Size of dataframe after exclusion of child speech")
dim(utterance_data)

#keep only utterances where neither word nor morpheme field is NA
utterance_data[!is.na(utterance_data[,"utterance"]) & !is.na(utterance_data[,"utterance_morphemes"]),]->utterance_data
print("Size of dataframe after exclusion of NA")
dim(utterance_data)

# some Japanese & Chintang utterances consist of only one consonant (ie the sentence is one consonant)
utterance_data[grep("^[bcdfghjklmnpqrstvwxz]$",utterance_data$utterance,invert=T),]->utterance_data
print("Size of dataframe after exclusion of one-consonant utterances")
dim(utterance_data)

#keep only utterances where neither word nor morpheme field contains ???
utterance_data[grep("???",as.character(utterance_data[,"utterance"]),invert=T,fixed=T),]->utterance_data #remove sentences with untranscribed material
utterance_data[grep("???",as.character(utterance_data[,"utterance_morphemes"]),invert=T,fixed=T),]->utterance_data #remove sentences with untranscribed material
utterance_data[grep("???",as.character(utterance_data[,"utterance"]),invert=T,fixed=T),]->utterance_data #remove sentences with untranscribed material
utterance_data[grep("???",as.character(utterance_data[,"utterance_morphemes"]),invert=T,fixed=T),]->utterance_data #remove sentences with untranscribed material
print("Size of dataframe after exclusion of ???")
dim(utterance_data)

#Chintang has two morphemes that have been annotated with a non-pronunciation code
utterance_data[grep("FS_C",as.character(utterance_data[,"utterance_morphemes"]),invert=T,fixed=T),]->utterance_data 
utterance_data[grep("FS_N",as.character(utterance_data[,"utterance_morphemes"]),invert=T,fixed=T),]->utterance_data 
print("Size of dataframe after exclusion of Chintang FS_C and FS_N")
dim(utterance_data)

print("$$$$$$$$$ ATTEMPT TO DETECT PROBLEMATIC CASES $$$$$")
print("Print character, language, and level being targeted, then first 10 lines including that character (both morpheme and utterance representation)")
# initial attempt to find problematic issues
toremove=c("^","'","(",")","&","?",".",",","=","…","!","_","/","।","«","‡","§","™","•","�","Œ","£","±","-")
for(thiscar in toremove) {
  for(LANGUAGE in c("Chintang","Japanese")){
    for(LEVEL in c("words","morphemes")){  
      if(LEVEL == "words") selcol <-"utterance" else if(LEVEL=="morphemes") selcol<-"utterance_morphemes" else print("BAD LEVEL")
      print(paste(thiscar,LANGUAGE,LEVEL)) 
      x=utterance_data[utterance_data$language==LANGUAGE,]
      print(x[grep(thiscar,x[,selcol],fixed=T)[1:10],c("utterance","utterance_morphemes")])
    }}}

print("$$$$$$$$$ FOCUS ON CHINTANG MORPHEMES $$$$$")
LANGUAGE="Japanese"
selcol="utterance_morphemes"
x=utterance_data[utterance_data$language==LANGUAGE,selcol]
print(paste("now checking the context for codes starting with &"))
y=x[grep("&",x)]
y=gsub(".*&","&",y)
y=gsub(" .*","",y)
y=y[!is.na(y)]
print(table(y))
illegalchars=c("&ADV","&CAUS","&COND","&CONN","&NEG","&IMP","&PAST","&POL","&PRES","&QUOT","&SGER","-HON_","_NEG")
for(thiscar in illegalchars) x<-gsub(thiscar,"",x,fixed=T)

for(thischar in c("_","=",".","^","&",":")){
  print(paste("now checking the context of",thischar))
  y=as.character(x[grep(thischar,x,fixed=T)])
  print(y[1:100])
}


print("$$$$$$$$$ FOCUS ON JAPANESE MORPHEMES $$$$$")
#focus on Japanese
LANGUAGE="Japanese"
selcol="utterance_morphemes"
x=utterance_data[utterance_data$language==LANGUAGE,selcol]
print(paste("now checking the context for codes starting with &"))
y=x[grep("&",x)]
  y=gsub(".*&","&",y)
  y=gsub(" .*","",y)
  y=y[!is.na(y)]
  print(table(y))
  illegalchars=c("&ADV","&CAUS","&COND","&CONN","&NEG","&IMP","&PAST","&POL","&PRES","&QUOT","&SGER","-HON_","_NEG")
  for(thiscar in illegalchars) x<-gsub(thiscar,"",x,fixed=T)
  
for(thischar in c("_","=",".","^","&",":")){
  print(paste("now checking the context of",thischar))
  y=as.character(x[grep(thischar,x,fixed=T)])
  print(y[1:100])
}

  print("$$$$$$$$$ ACTUAL DATA SELECTION AND SAVING $$$$$")
  
for(LANGUAGE in c("Chintang","Japanese")){
  for(LEVEL in c("words","morphemes")){
    # LANGUAGE="Japanese"
    # LEVEL="morphemes"
    
    if(LEVEL == "words") selcol <-"utterance" else if(LEVEL=="morphemes") selcol<-"utterance_morphemes" else print("BAD LEVEL")

    #get codes for all utts in this corpus
    levels(factor(morpheme_data[morpheme_data$language==LANGUAGE, "unique"]))->corpus_utts
    
    #get codes for only utts in this corpus that do NOT contain codes for foreign languages
    levels(morpheme_data$word_language)->all_lang
    all_lang[grep(LANGUAGE,all_lang,invert=T)]->bad_lang #get all the language tags that do not include our key language
    levels(factor(morpheme_data[morpheme_data$word_language %in% bad_lang,"unique"]))->exclude_utts #get the utts that do have foreign words
    native_utts<-corpus_utts[!(corpus_utts %in% exclude_utts)] #get the opposite subset
    
    print(paste("now processing",LANGUAGE,LEVEL))
    #subset to utterances of the language under study 
    sel_utts<-utterance_data[ utterance_data$language==LANGUAGE,c('unique', selcol)]
    print("Size of dataframe for this language and level before cleaning")
    print(dim(sel_utts))
    clean_corpus<-clean(sel_utts,toremove,selcol,LANGUAGE,LEVEL)
    print("")
    print("Size of dataframe for this language and level AFTER cleaning")
    print(dim(clean_corpus))
    
    write.table(clean_corpus[   ,selcol] , 
                file=paste0(RESULT_FOLDER,"/full_",LANGUAGE,"_",LEVEL,".txt"), 
                row.names=F,col.names=F,quote=F)
    
    write.table(clean_corpus[clean_corpus$unique %in% native_utts,selcol] , 
                file=paste0(RESULT_FOLDER,"/noforeign_",LANGUAGE,"_",LEVEL,".txt"),  
                row.names=F,col.names=F,quote=F)
    
  }
}
sink()
