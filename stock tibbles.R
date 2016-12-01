
##rm(list = ls())
install.packages("data.table")
install.packages("GGally")
install.packages("GGally")
install.packages("flexclust")



library(data.table)
library(Quandl)
library(quantmod)
library(dplyr)
library(tidyr)
library(GGally)
library(flexclust)
library(purrr)
library(modelr)
library(ggplot2)



qURL <- paste("https://s3.amazonaws.com/static.quandl.com/tickers/nasdaq100.csv", sep = "")

##return(qURL)
mydf <- read.csv(qURL, header = TRUE)
mydf[] <- lapply(mydf, as.character)
mystocktibble <- as_data_frame(mydf)



##Make a function that will append additional sets from other Indexes   

appendData <- function(CODE){
  
  qURL <- paste("https://s3.amazonaws.com/static.quandl.com/tickers/", CODE, ".csv", sep = "")
  
  ##return(qURL)
  mydf <- read.csv(qURL, header = TRUE)
  mydf[] <- lapply(mydf, as.character)
  mynewtibble <- as_data_frame(mydf)
  
  
mystocktibble <<- union(mystocktibble, mynewtibble) 
  
 
}




myIndices <- c("SP500", "dowjonesA", "NASDAQComposite", "nasdaq100", "NYSEComposite", "FTSE100")



myIndices <- c("SP500", "dowjonesA", "NASDAQComposite", "nasdaq100", "NYSEComposite", "FTSE100")

##myIndices <- c("SP500", "dowjonesA", "NASDAQComposite", "nasdaq100", "NYSEComposite", "FTSE100")


for(indice in myIndices){
  
  appendData(indice)
}
  


mystocktibble <- mystocktibble %>% filter(free_code != "")

mystocktibble <- mystocktibble %>% filter(free_code != "WIKI/LBTYK" & free_code != "GOOG/NASDAQ_LMCK" & free_code != "WIKI/NXPI")



mystocktibble <-mystocktibble %>% group_by(ticker) %>% top_n(n = 1 , wt = free_code) %>% group_by(ticker) %>% top_n(n = 1 , wt = name) 



mytt <- mystocktibble %>% filter(free_code %like% "A" & free_code %like% 'N')






mystocktibble <- mytt
##mytt <- mystocktibble %>% filter(row_number() <= 10 & row_number() > 0)

get_Quandl_Chart_Data <- function(string) {
  print(string)
  mydf <- Quandl(string, api_key="evdFxFw2Tf2BDSGtXUvg")
  mydf$Date <- as.numeric(gsub("-", "", as.character(mydf$Date)))
  return(mydf)
  
}


mystocktibble <- mystocktibble %>% 
  mutate(chart = map(free_code, get_Quandl_Chart_Data))
mystocktibble









##mystocktibbleTech <- mystocktibble %>% filter(ticker == "AAPL" | ticker =="GOOG")


stock_model <- function(df) {
  lm(Close ~ Date, data = df)
}

##Add Chart and Residuals

mystocktibble <- mystocktibble %>% 
  mutate(model = map(chart, stock_model))

mystocktibble <- mystocktibble %>% 
  mutate(
    resids = map2(chart, model, add_residuals)
  )




resids <- unnest(mystocktibble, resids)
resids



resids %>% 
  ggplot(aes(Date, resid)) +
  geom_line(aes(group = ticker), alpha = 1 / 3) + 
  geom_smooth(se = FALSE) +   facet_wrap(~ticker)






resids %>% filter(ticker == "GOOG") %>%
  ggplot(aes(Date, resid, group = ticker)) +
  geom_line(alpha = 1 / 3) + 
  facet_wrap(~ticker)





glance <- mystocktibble %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance, .drop = TRUE)
##glance

##display model stuff for 
glance %>% 
  ggplot(aes(ticker, r.squared)) + 
  geom_jitter(width = 0.8)

glance %>% 
  ggplot(aes(ticker, r.squared)) + 
  geom_jitter(width = 0.8)



tibbleforcluster <- mystocktibble[,c(1,5)]

myclusterdata <- unnest(tibbleforcluster)
myclusterdata <-myclusterdata %>% mutate(Change = Close - Open, ChangePercentage = (Close-Open)/(Open))
tttdf <- as_data_frame(dcast(myclusterdata,Date ~ ticker , value.var = "Change"))




ggcorr(tttdf)


##corrmatdf <- as_data_frame(as.data.frame(cor(tttdf, use = "complete.obs")))


mycmp <- dist(abs(cor(tttdf, use = "complete.obs")))
plot(hclust(mycmp))
kmeans(mycmp, 2)


mycmp
whatthis <- hclust(mycmp)
plot(whatthis)




kclustsSG <- data.frame(k=1:9) %>% group_by(k) %>% do(kclust=kmeans(mycmp, .$k))
# library(broom)
clusters <- kclustsSG %>% group_by(k) %>% do(tidy(.$kclust[[1]]))
assignmentsSG <- kclustsSG %>% group_by(k) %>% do(augment(.$kclust[[1]], mycmp))
clusteringsSG <- kclustsSG %>% group_by(k) %>% do(glance(.$kclust[[1]]))
# 
# 



p1 <- ggplot(assignments, aes(x1, x2)) + geom_point(aes(color=.cluster)) + facet_wrap(~ k)
p1


whatthis[1]
