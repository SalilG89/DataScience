############################
##rm(list=ls())

## Kaggle Competition 2016 Primary Results
## Author:  Salil Gupta
##https://www.kaggle.com/benhamner/2016-us-election
#############################################
install.packages("reshape2")


install.packages(c("choroplethr", "choroplethrMaps")) 
install.packages('jpeg', repos="http://cran.r-project.org")
install.packages('corrplot', repos="http://cran.r-project.org")
install.packages('choroplethr', repos="http://cran.r-project.org")

install.packages(path_to_file, repos = NULL, type="source")


library(maps)
library(corrplot)
library(ggplot2)
library(dplyr)
library(reshape2)
library(RSQLite)
library(choroplethr)
library(choroplethrMaps)
library(rpart)
library(rpart.plot)
library(datasets)
library(caret)

#############################################
##              SQLite Code to connect to datbase
##############################################

dbpath = "H:/PE/2016_presidential_election/database.sqlite"
db <- dbConnect(dbDriver("SQLite"), dbpath)
dbListTables(db)

countyfacts <- dbGetQuery(db, "select *  from county_facts")
cfd <- dbGetQuery(db, "select *  from county_facts_dictionary")
presults <- dbGetQuery(db, "select *  from primary_results")
rsPR <- data.frame(presults$fips,presults$party,presults$candidate, presults$fraction_votes)

####################################################
## Convert candidates' percentage of votes from long to wide
####################################################
colnames(rsPR) <- c("fips","party","cand","perVotes")
newdf <- dcast(rsPR,fips ~ cand , value.var = "perVotes")

mydf <- merge(newdf,countyfacts, by = "fips")
mydf$ID <- rownames(mydf)
##Derived column 
##head(mydf,1)

###########################################
## derived columns to get county winners 
###############################

demdf <- data.frame(mydf$`Hillary Clinton`, mydf$`Bernie Sanders`)
demwinners <- colnames(demdf)[apply(demdf,1,which.max)]

repubdf <- data.frame(mydf$`Ben Carson`, mydf$`Carly Fiorina`, mydf$`Chris Christie`, mydf$`Jeb Bush`, mydf$`John Kasich`, mydf$`Marco Rubio`, mydf$`Ted Cruz`, mydf$`Donald Trump`, mydf$`Ted Cruz`, mydf$`Mike Huckabee` ,mydf$`Rand Paul`, mydf$`Rick Santorum`)
rwinners <- colnames(repubdf)[apply(repubdf,1,which.max)]

########################################################
##attach ID field to merge on 
######################################################

dwdf <- data.frame(demwinners)
dwdf$ID <- rownames(dwdf)

rwdf <- data.frame(rwinners)
rwdf$ID <- rownames(rwdf)



winners <- merge(rwdf,dwdf, by = "ID")
mydf <- merge(winners,mydf, by = "ID")

############################
## functions to produce plots easily from dataset
##############################


#### US MAP PLOT
####
myplotfxn <- function(valcol)
{
  
  df <- data.frame(mydf$fips, mydf[,valcol] )
  colnames(df) <- cbind("region", "value")
  
  
  return(county_choropleth(df, legend = valcol))
  
}
################################
######INdIVIDUAL STATE PLOT
###################################



myplotfxnst <- function(valcol,state)
{
  
  df <- data.frame(mydf$fips, mydf[,valcol] )
  colnames(df) <- cbind("region", "value")
  
  return(county_choropleth(df, state_zoom = state, legend = valcol))
  
}

##myplotfxn("INC110213")
##myplotfxnst("INC110213","iowa")

##ggplot(aes(x=RHI725214,y=AGE775214,color=mydf$rwinners),data=mydf)+geom_jitter()

treeFormu <- formula(rwinners ~ RHI125214 + HSG445213 + POP060210 + INC910213 + VET605213 + AGE775214 + EDU685213 + AFN120207 + POP060210)

rprimindex <- createDataPartition(y=mydf$rwinners, times = 1, p =.5, list = F)
mydf.train <-mydf[rprimindex, ]
mydf.test  <-mydf[-rprimindex, ]

treeModel <- rpart(treeFormu, method = "class", data=mydf.train)

# 
rpart.plot(treeModel,branch=0,branch.type=2,type=1,extra=102,shadow.col="pink",box.col="gray",split.col="magenta")

dropcols <- c("rwinners", "demwinners","area_name","state_abbreviation" )
cordf <- mydf[ , !names(mydf) %in% dropcols ]


i <- sapply(cordf, is.character)
cordf[i] <- lapply(cordf[i], as.numeric)


mycors <- cor(cordf, use="complete.obs", method="kendall") 

myelectioncorplot <- corrplot(mycors,method = "circle")

## create a visualization from the corelation matrix

##highest correlations


ggplot(cordf, aes(x = cordf$`Bernie Sanders`, y = cordf$`Donald Trump`)) + geom_point(shape =1) + geom_smooth(method = lm)

ggplot(cordf, aes(x = cordf$`Hillary Clinton`, y = cordf$`Donald Trump`)) + geom_point(shape =1) + geom_smooth(method = lm)
