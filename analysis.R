library(dplyr)
Afile<- "UCI HAR Dataset.zip"
if(!file.exists(Afile)){download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile=Afile)}
if (!file.exists(Afile)) {unzip(Afile)}
Trs<-read.table(paste(getwd(),"/","UCI HAR Dataset","/","train","/","subject_train.txt", sep = ""), as.is = T)
Trx<-read.table(paste(getwd(),"/","UCI HAR Dataset","/","train","/","X_train.txt", sep = ""), as.is = T)
Try<-read.table(paste(getwd(),"/","UCI HAR Dataset","/","train","/","y_train.txt", sep = ""), as.is = T)
Tss<-read.table(paste(getwd(),"/","UCI HAR Dataset","/","test","/","subject_test.txt", sep = ""), as.is = T)
Tsx<-read.table(paste(getwd(),"/","UCI HAR Dataset","/","test","/","X_test.txt", sep = ""), as.is = T)
Tsy<-read.table(paste(getwd(),"/","UCI HAR Dataset","/","test","/","y_test.txt", sep = ""), as.is = T)
f<- read.table(paste(getwd(),"/","UCI HAR Dataset","/","features.txt",sep = ""), as.is = TRUE)
acl<- read.table(paste(getwd(),"/","UCI HAR Dataset","/","activity_labels.txt",sep = ""), as.is = TRUE)
totalx <- rbind(Trx,Tsx)
totaly <- rbind(Try,Tsy)
totals <- rbind(Trs,Tss)
keep<-f[grep("mean\\(\\)|std\\(\\)",f[,2]),]
totalx <- totalx[,keep[,1]]
colnames(totaly) <- "activity"
totaly$activitylabel <- factor(totaly$activity, labels = as.character(acl[,2]))
activitylabel <- totaly[,-1]
colnames(totalx) <- f[keep[,1],2]
colnames(totals) <- "subject"
total <- cbind(totalx, activitylabel, totals)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)