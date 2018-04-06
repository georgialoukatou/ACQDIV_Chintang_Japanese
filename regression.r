#!/usr/bin/env Rscript
args<-commandArgs(trailingOnly=TRUE)

data<-read.csv(args[1])

fit <- lm(fscores ~ language * level * subalgorithm + (1 | subcorpus)), data)
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
