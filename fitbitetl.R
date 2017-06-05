rm(list = ls())

differenceofdays <- as.integer(difftime(Sys.Date(), 
                    strptime("1.05.2017", format = "%d.%m.%Y"),units="days"))


start <- as.POSIXct("2017-05-01")
interval <- 60*60*24

end <- start + as.difftime(differenceofdays, units="days")


posdates <- seq(from=start, by=interval, to=end)


datesdf<- as.data.frame(posdates)


datesdf$formatdates <- as.character(as.Date(datesdf$posdates, "%Y%M/%D"))


library(fitbitScraper)
library(ggplot2)
library(dplyr)

library(tibble)



rundate <- datesdf$formatdates[1]



dfsteps <- get_intraday_data(fitbitcookies, what="steps", date= rundate)
dfheartrate <- get_intraday_data(fitbitcookies, what="heart-rate", date= rundate)


library(tibble)


get_HeartData <- function(chardate) {
  print(chardate)
  dfsteps <- get_intraday_data(fitbitcookies, what="steps", date= chardate)
  
  return(dfsteps)
  
}



get_stepsdata <- function(chardate) {
  print(chardate)
  dfsteps <- get_intraday_data(fitbitcookies, what="steps", date= chardate)
  
  return(dfsteps)
  
}




datestibble <- as_tibble(datesdf)

fitbitcookies <- login(email="salildotdata@gmail.com", password="WANDer87") 
datestibble <- datestibble %>% 
  mutate(heartdata = map(formatdates, get_HeartData))%>% 
  mutate(stepsdata = map(formatdates, get_stepsdata))
datestibble
