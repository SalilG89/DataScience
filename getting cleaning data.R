
library(plyr)

## If data directory exists, change to that directory.
## Else, create data directory, download and unzip raw data files.
if(file.exists("./data")) {
  setwd("./data")
} else {
  dir.create("./data")
  fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="./data/zipfile.zip",method="curl", mode = "wb")
  setwd("./data")
  unzip("zipfile.zip", files = NULL, list = FALSE, overwrite = TRUE,
        junkpaths = FALSE, exdir = ".", unzip = "internal",
        setTimes = FALSE)
}

## Read raw data files into memory for processing.
trainSubj<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
trainY<-read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainX<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
testSubj<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
testY<-read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testX<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
features<-read.table("./UCI HAR Dataset/features.txt",header=FALSE)
activityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)

## Join train and test files.
subjects<-rbind(trainSubj,testSubj)
activities<-rbind(trainY,testY)
readings<-rbind(trainX,testX)

## Set counter maximums for later.
tmp<-count(unique(subjects)); subjectNum<-sum(tmp$freq)
tmp<-count(unique(activityLabels)); labelNum<-sum(tmp$freq)

## Remove working files.
rm(trainSubj,testSubj,trainY,testY,trainX,testX)

## Decode activity label and put result in new activity name column.
activities$activityName<-activityLabels[activities$V1,2]

## Clean feature names removing problematic text
cleanFeatures<-gsub("([()])", "", features[,2])
cleanFeatures<-gsub("([-])","",cleanFeatures)
cleanFeatures<-gsub("([,])","",cleanFeatures)
colnames(readings)<-cleanFeatures

## Join columns to create master file renaming some columns.
master<-cbind(activities,subjects)
colnames(master)<-c("activityLabel","activityName","activitySubject")
master<-cbind(master,readings[,41:46],readings[,214:215],readings[,253:254],
              readings[,266:271],readings[,345:350],readings[,424:429],
              readings[,503:504],readings[,516:517],
              readings[,529:530],readings[,542:543])

## Remove working files
rm(subjects,activities,readings,features,cleanFeatures)

## Sort master - used for debugging master file creation only.
master<-master[order(master$activitySubject,desc(master$activityLabel)),]

## Initialize return matrix for processing.
output<-matrix(NA,labelNum*subjectNum,length(master))
output<-as.data.frame(output)
colnames(output)<-names(master)
outputCtr<-1

## Couldn't find an easy way to melt/dcast or data.table/.SD given the
## 70 means to be returned. So, looping through manually.
for(i in 1:labelNum){
  tmpAct<-master[master$activityLabel==i,]
  for(j in 1:subjectNum){
    tmpActSubj<-tmpAct[tmpAct$activitySubject==j,]
    output[outputCtr,1]<-i
    output[outputCtr,2]<-as.character(activityLabels[i,2])
    output[outputCtr,3]<-j
    for(k in 1:(length(master)-3)){
      output[outputCtr,k+3]<-mean(tmpActSubj[,k+3])
    }
    outputCtr<-outputCtr+1
  }
}
## Save output files.
write.table(master,"masterData.txt",row.names=T,col.names=T) 
write.table(output,"activitySubjectMeans.txt",row.names=T,col.names=T) 
listOfVariables <- data.frame(names(output))
write.csv(listOfVariables,"listOfVariables.csv")

## Remove working files.
rm(tmp,tmpAct,tmpActSubj,activityLabels,listOfVariables)
rm(master,output,i,j,k,labelNum,outputCtr,subjectNum)
setwd("../")