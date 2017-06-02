library(fitbitScraper)
library(ggplot2)
library(stringr, lib.loc = "C:\\rw\\packages\\library\\")
library(dplyr)

install.packages("lubridate")


fitbitcookies <- login(email="salildotdata@gmail.com", password="WANDer87") 


get_premium_export(fitbitcookies, what = "ACTIVITIES", start_date = "2017-05-01",  end_date = "2017-05-21")



rundate <- "2017-05-29"

dfsteps <- get_intraday_data(fitbitcookies, what="steps", date= rundate)
dfheartrate <- get_intraday_data(fitbitcookies, what="heart-rate", date= rundate)










  
ggplot(dfsteps) + geom_bar(aes(x=time, y=steps, fill=steps), stat="identity") + 
  xlab("") +ylab("steps")
  
  ggplot(dfheartrate) + geom_bar(aes(x=time, y=bpm, fill=bpm), stat="identity") + 
  xlab("") +ylab("BPM") 
  
  
  theme(axis.ticks.x=element_blank(), 
        panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(), 
        panel.grid.minor.y = element_blank(), 
        panel.background=element_blank(), 
        panel.grid.major.y=element_line(colour="gray", size=.1), 
        legend.position="none") 



sleepdf[2] <- get_sleep_data(fitbitcookies, start_date="2017-04-30", end_date="2017-05-03")


sleepdataframe <- as.data.frame(sleepdataframe) sleepdf[2]



sleepdataframe$df.endTime


sleepdataframe$df.date


ggplot(df) + geom_bar(aes(x=time, y=steps, fill=steps), stat="identity") + 
  xlab("") +ylab("steps") + 
  theme(axis.ticks.x=element_blank(), 
        panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(), 
        panel.grid.minor.y = element_blank(), 
        panel.background=element_blank(), 
        panel.grid.major.y=element_line(colour="gray", size=.1), 
        legend.position="none") 