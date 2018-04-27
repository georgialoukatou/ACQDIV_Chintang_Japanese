#!/usr/bin/env Rscript
args<-commandArgs(trailingOnly=TRUE)
resfile=args[1]
statfile=args[2]
folder=args[3]
#resfile<-"results.txt"
#statfile="stats.txt"
#folder="/scratch1/users/acristia/acqdiv/"

#COMPILE RESULTS DATA
data<-read.csv(resfile)
# colnames(data)<-c("folder" ,
# "token_precision" ,"token_recall", "token_fscore" ,
# "type_precision", "type_recall", "type_fscore" ,
# "boundary_precision", "boundary_recall", "boundary_fscore" ,
# "boundary_NE_precision" ,"boundary_NE_recall" ,"boundary_NE_fscore")
for(thiscol in c("boundary_NE_precision" ,"boundary_NE_recall" ,"boundary_NE_fscore")) data[,thiscol]=as.numeric(as.character(data[,thiscol]))
summary(data)
data$fscores=data$token_fscore
#clean up and extract info from files named like /scratch1/users/acristia/acqdiv//Chintang/morphemes/full-tags.txt_eval.ag.txt
# and like Japanese/words/full_part9/tags.txt_eval.ftp_rel.txt
data$folder=gsub("//","/",data$folder)
data$folder=gsub(folder,"",data$folder)
data$language=gsub("/.*","",data$folder)
data$level=gsub("/.*","",gsub(".*[ge]/","",data$folder))
data$subalgorithm=gsub(".txt","",gsub(".*eval.","",data$folder))
data$file=gsub("tags.txt.*","",data$folder)
  
# divergence in notation between full and part
data$corpus=NA
data$corpus[grep("_part",data$folder,invert=T)]=gsub("-tags","",gsub("\\..*","",gsub(".*/","",data$folder[grep("_part",data$folder,invert=T)])))
data$subcorpus=NA
data$subcorpus[grep("_part",data$folder)]=gsub(".*/","",gsub("/tags.*","",data$folder[grep("_part",data$folder)]))

summary(data)

#COMPILE STATS DATA
stat<-read.csv(statfile)
stat$folder=gsub("//","/",stat$folder)
stat$folder=gsub(folder,"",stat$folder)
stat$file=gsub("stats.txt.*","",stat$folder)

#combine and save
merge(data,stat,by="file")->data
write.table(data,paste0(folder,"/res-stat.txt"),row.names=F,quote=T,sep=",")
read.csv(paste0(folder,"/res-stat.txt"))->data


fit <- lm(fscores ~ language * level * subalgorithm + (1 / file), data)
summary(fit)

######## PLOT 
jpeg(args[2])

palette(c("black", "red", "green3", "blue", "orange", "gray"))
newdata <- data
newdata$subalgorithm = factor(newdata$subalgorithm, c("AGu", "BTP_abs", "FTP_abs", "BTP_rel", "FTP_rel", "DiBS"))
newdata$xval= ifelse(newdata$level=="words",0,2) + ifelse(newdata$language=="Chintang",1,2) + (as.numeric(newdata$subalgorithm)/10 - mean(as.numeric(newdata$subalgorithm)/10))
par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
#part<-split(newdata$token_fscore, 24)
plot(newdata[1:10]$token_fscore~newdata$xval,cex=3, type="n")
plot(newdata$token_fscore~newdata$xval,col=as.numeric(as.factor(newdata$subalgorithm), palette), pch="x",xaxt='n',xlab="", ylab='Token F-scores', ylim=c(0.1, 0.8), cex.lab = 1.3, cex.axis = 1, main="F-scores for language, algorithm and level", cex.main=1.3)
axis(1,at=1:4,labels=c("Chintang","Japanese","Chintang","Japanese"), cex.axis = 1.3)
axis(1,at=c(1.5,3.5),labels=c("Words","Morphemes"),line=2, cex.axis = 1.3)
legend('topright', inset=c(-0.2,0), legend=c('AGu', 'BTPa', 'FTPa', 'BTPr', 'FTPr', 'DiBS' ), pch=c("x","x","x","x","x","x"), col=c('black','red', 'green3', 'blue','orange', 'grey'), cex=1, pt.cex=1)

dev.off()
