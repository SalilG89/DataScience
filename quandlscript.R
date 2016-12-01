install.packages("Quandl")
##rm(list = ls())
install.packages("quantmod")
library(Quandl)
library(quantmod)


library(dplyr)
library(tidyr)




Quandl("WIKI/GOOGL", api_key="evdFxFw2Tf2BDSGtXUvg")



mydf <- Quandl("WIKI/GOOG", api_key="evdFxFw2Tf2BDSGtXUvg")



mydffb <- Quandl("WIKI/FB", api_key="evdFxFw2Tf2BDSGtXUvg")


symbols <- stockSymbols()


exchanges <- symbols  %>% distinct(Exchange)


symbols  %>% distinct(Symbol)



nasdaqsymbols <- read.csv("https://s3.amazonaws.com/static.quandl.com/tickers/nasdaq100.csv", header = TRUE)
nasdaqsymbols <- read.csv("https://s3.amazonaws.com/static.quandl.com/tickers/nasdaq100.csv", header = TRUE)


getDataInTibbles <- function(qURL){
  
  mytibble <- as_data_frame(read.csv(qURL, header = TRUE))
  return(mytibble)
}




c("sp500", "dowJonesA", "NASDAQComposite", "nasdaq100", "NYSEComposite", "FTSE100")













getDataInTibbles <- function(CODE){
  
  qURL <- paste("https://s3.amazonaws.com/static.quandl.com/tickers/", CODE, ".csv", sep = "")
  
  ##return(qURL)
  mydf <- read.csv(qURL, header = TRUE)
  mydf[] <- lapply(mydf, as.character)
  mytibble <- as_data_frame(mydf)
  
  
  
  
  return(mytibble)
}





tibSP500 <- getDataInTibbles("SP500")
tibdowJones <- getDataInTibbles("dowjonesA")
tibNasdaqComp <- getDataInTibbles("NASDAQComposite")
tibNasdaq100 <- getDataInTibbles("nasdaq100")
tibNYSEComp <- getDataInTibbles("NYSEComposite")
tibFTSE100 <- getDataInTibbles("FTSE100")










testStockData <- union(tibSP500, tibdowJones)
testStockData <- union(testStockData, tibNasdaqComp)

StockData <- union(tibSP500, tibdowJones, tibNasdaqComp, tibNasdaq100, tibNYSEComp, tibFTSE100)
AllStockData <- unionall(tibSP500, tibdowJones, tibNasdaqComp, tibNasdaq100, tibNYSEComp, tibFTSE100)






typeof(symbols)

tibNasdaqSymbols <- as_data_frame(nasdaqsymbols)



tibNasdaqSymbols