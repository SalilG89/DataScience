install.packages("syuzhet")
library(syuzhet)

library(dplyr)
devtools::install_github("hrbrmstr/streamgraph")
install.packages("streamgraph")


library(streamgraph)
library(viridis)

##Read in Flat File produced by python scripts
mypipeff <- read.table("H:/PY/bernietweetsff.txt", sep = "|", header = TRUE)
head(mypipeff,1)

## Convert Factor Columns to Character Columns
i <- sapply(mypipeff, is.factor)
mypipeff[i] <- lapply(mypipeff[i], as.character)

dfgooddates <- mypipeff



##Format Twitter Created_at 
dfgooddates$cleantime <- as.POSIXct(dfgooddates$created_at, format = "%a %b %d %H:%M:%S +0000 %Y")

##head(dfgooddates,1)

##Derive Sentiments using Syuzhet package 
tweetsentiments <- get_nrc_sentiment(dfgooddates$tweet)

DFwSentiments <- data.frame(dfgooddates$id, dfgooddates$cleantime, tweetsentiments)


##head(tweetsentiments,1)

write.csv(DFwSentiments, file = "TweetSentiments2.csv")

##Convert sentiment columns to rows
pivotDF <- melt(DFwSentiments, id.vars = c("dfgooddates.id", "dfgooddates.cleantime"))

## Write 
write.csv(pivotDF, file = "pivotsentiments.csv")





pivotDF %>% 
  mutate(date=as.Date(dfgooddates.cleantime, format="%m/%d/%y")) %>% 
  streamgraph(key="variable", value="value", offset="expand") %>% 
  ##sg_fill_manual(stock_colors) %>% 
  ##sg_axis_x(tick_interval=10, tick_units="s") %>% 
  sg_legend(TRUE, "Ticker: ")







#typeof(mypipeff[[1,2]])
#class(mypipeff[[1,2]])


#head(stocks,1)

##library(lubridate)
##TIME_FORMAT <- "%a %b %d %H:%M:%S %z %Y"

##DFwSentiments$created_at <- strptime(as.character(DFwSentiments$created_at), TIME_FORMAT)
##DFwSentiments$hour <- hour(DFwSentiments$created_at)
##DFwSentiments$minute <- minute(DFwSentiments$created_at)
##DFwSentiments$time <- sprintf('%02d:%02d', DFwSentiments$hour, DFwSentiments$minute)
##head(DFwSentiments,1)
##typeof(DFwSentiments[[1,2]])
##class(DFwSentiments[[1,2]])
