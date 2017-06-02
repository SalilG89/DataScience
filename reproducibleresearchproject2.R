
getwd()

StormDataURL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
download.file(StormDataURL,"StormData.csv.bz2")



StormDf <- read.csv(bzfile("StormData.csv.bz2"))

head(StormDf,10)