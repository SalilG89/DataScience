WorldBankDf <- read.csv("WorldBankData.csv", header = TRUE)
##unique(WorldBankDf$Series.Name)
##rm(list=ls())


library(googleVis)
library(sqldf)
install.packages("taRifx")
library(taRifx)
library(reshape2)



WorldBankDf <- read.csv("WorldBankData.csv", header = TRUE)


setnames(WorldBankDf, old = c("Series.Name"), new = c("Measure"))
WorldBankDf$MeasureRC <- WorldBankDf$Measure
levels(WorldBankDf$MeasureRC) <-   c("Carbon1" ,"Carbon","Carbonpc","GDPGrowth","GDPpc1","GDPpc2","GDPpc3")





dfMelted <- melt(WorldBankDf, id.vars = c("CountryName", "CountryCode", "Measure", "MeasureRC"))



dfMelted$Year <- as.numeric(gsub("X","",as.character(dfMelted$variable)))
chartData <- dcast(dfMelted,CountryName + CountryCode + Year ~ MeasureRC , value.var = "value")
##chartDataNum <- japply( chartData, which(sapply(chartData, class)=="character"), as.numeric )

str(chartData)
myWBchart <- gvisMotionChart(chartDataNum, idvar = "CountryCode", timevar = "Year", xvar = "GDPGrowth",
                           yvar = "Carbon", 
                           ##colorvar = "",
                           ##sizevar = "Claimcount",
                           date.format = "%Y")
plot(myWBchart)








##write.csv(dfMelted, file = "dfMelted.csv")

##write.csv(newdf, file = "newdf.csv")




MeasureVariables <-  


sqldf("
select  * from chartDataNum limit 10
")

levels(dfMelted$Measure)
























