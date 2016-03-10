#####################################

###########The Following fxn produces a wordcloud from a tweet flat file 
###Author:  Salil Gupta
##Created at 12/10/2014
#######################
install.packages("tm", repos="http://cran.r-project.org")
install.packages("wordcloud", repos="http://cran.r-project.org")
library(tm)
library(syuzhet)
library(wordcloud)

WCfromTextFF <- function(fileloc,pngloc)
{
  
  
  ffdf <- read.table(fileloc, sep = "|", header = FALSE)
  colnames(ffdf) <- c("Id" , "tweet" , "created_at" , "geo", "coord" )
  
  
  dropcols <- c("geo", "coord")
  ffdf <- ffdf[ , !names(ffdf) %in% dropcols ]
  
  
  
  
  i <- sapply(ffdf, is.factor)
  ffdf[i] <- lapply(ffdf[i], as.character)
  
  ##ffdf$cleantime <- as.POSIXct(ffdf$created_at, format = "%a %b %d %H:%M:%S +0000 %Y")
  
  
  text <- paste(ffdf$tweet, sep = " ")
  
  
  
  myVectorSource <- VectorSource(text)
  
  myCorpus <- Corpus(myVectorSource)
  myFreqMatrix <- as.matrix(TermDocumentMatrix(myCorpus))
  
  word_freqs = sort(rowSums(myFreqMatrix), decreasing = TRUE)
  
  myclouddf <- data.frame(word = names(word_freqs), freq = word_freqs)
  
  
  
  png(pngloc, width=12, height=8, units="in", res=300)
  wordcloud(myclouddf$word, myclouddf$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
  dev.off()
  
}





