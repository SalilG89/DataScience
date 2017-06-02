setwd("C:\\rw\\")



if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")) {
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
  unzip(temp)
  unlink(temp)
}


ActivityDf <- read.csv("activity.csv")


ActivityDf$DayOfWeek <- weekdays(as.Date(ActivityDf$date))
##ActivityDf$DateTime<- as.POSIXct(ActivityDf$date, format="%Y-%m-%d")


ActivityDf_Tidy <- ActivityDf[complete.cases(ActivityDf),]

SumOfSteps_By_Day <- 
  ActivityDf_Tidy %>% 
  group_by(date) %>%
  summarise(
    SumSteps = sum(steps)
    # the average positive delay
  )

AvgSteps_By_Interval <- 
  ActivityDf_Tidy %>% 
  group_by(interval) %>% 
  summarise(
    AvgSteps = mean(steps)
    # the average positive delay
  )

AvgSteps_By_DayOfWeekInterval <- 
  ActivityDf_Tidy %>% 
  group_by(DayOfWeek, interval) %>% 
  summarise(
    AvgSteps = mean(steps)
    # the average positive delay
  )



##names(SumOfSteps_By_Day)[2] <- "SumOfSteps"


hist(x = SumOfSteps_By_Day$SumSteps,  col = "blue",
     main = "Steps By Day",
     xlab = "Total Number of Steps Taken Each Day",
     breaks = 20
)


mean(SumOfSteps_By_Day$SumSteps)
median(SumOfSteps_By_Day$SumSteps)




##AvgSteps_By_Interval <- aggregate(steps ~ interval, ActivityDf_Tidy, mean)



plot(AvgSteps_By_Interval$interval,AvgSteps_By_Interval$AvgSteps, 
     type="l",      xlab="Interval",      ylab="Number of Steps",
     main="Average Number of Steps per Day by Interval")




MaxStepsInterval <- AvgSteps_By_Interval[which.max(AvgSteps_By_Interval$AvgSteps),1]


##Records with Missing Step Count
nrow(ActivityDf[is.na(ActivityDf$steps),])


MissingDataRecords <- ActivityDf[is.na(ActivityDf$steps),]




## Merge NA data with average weekday interval for substitution
MissingDataRecords_AvgSteps<-merge(MissingDataRecords, AvgSteps_By_DayOfWeekInterval, by=c("interval", "DayOfWeek"))

MissingDataRecords_AvgSteps  <- MissingDataRecords_AvgSteps[,c(5,4,1,2)]



colnames(MissingDataRecords_AvgSteps)[1] <- "steps"


ActivityDf_WImputations <- rbind(ActivityDf_Tidy, MissingDataRecords_AvgSteps)


SumOfSteps_By_Day_WImputations <- 
  ActivityDf_WImputations %>% 
  group_by(date) %>%
  summarise(
    SumSteps = sum(steps)
    # the average positive delay
  )



as.integer(mean(SumOfSteps_By_Day_WImputations$SumSteps))


as.integer(median(SumOfSteps_By_Day_WImputations$SumSteps))


hist(SumOfSteps_By_Day_WImputations$SumSteps, breaks=20, xlab="Steps", main = "Total Steps per Day with NAs Fixed", col="Green")
hist(SumOfSteps_By_Day$SumSteps, breaks=20, xlab="Steps", main = "Total Steps per Day with NAs Fixed", col="blue", add=T)
legend("topright", c("Imputed Data", "Non-NA Data"), fill=c("Green", "blue") )




ActivityDf_WImputations$WeekendOrWeekday <- ifelse(ActivityDf_WImputations$DayOfWeek %in% c("Saturday", "Sunday"), "Weekend", "Weekday")


distinct(ActivityDf_WImputations, DayOfWeek, WeekendOrWeekday)

##intervalTable2 <- ddply(mergeData, .(interval, DayCategory), summarize, Avg = mean(steps))

AvgSteps_ByIntervalIsWeekend <-
ActivityDf_WImputations %>% 
  group_by(interval, WeekendOrWeekday) %>% summarise(
    AvgSteps = mean(steps)
    # the average positive delay
  )



library(lattice)




xyplot(AvgSteps~interval|WeekendOrWeekday, data=AvgSteps_ByIntervalIsWeekend, type="l",  layout = c(1,2),
       main="Average Steps per Interval Based on Type of Day", 
       ylab="Average Number of Steps", xlab="Interval")