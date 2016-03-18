library(data.table)
library(ggplot2)




housingCols <- c("ACCESS", "MODEM", "FINCP" ,"FPARC", "HHT", "WORKSTAT", "FES", "WGTP")



housDF <- fread("H:\\Py\\csv_hus\\ss13husa.csv", select  = housingCols)



housDF$MODEM <- factor(housDF$MODEM)

housDF$ACCESS <- factor(housDF$ACCESS)




levels(housDF$ACCESS) <- c("Subscription", "Yes w/o Subscription", "No Access")
levels(housDF$MODEM) <- c("YES", "NO")


hDFwAccess <- subset(housDF, !is.na(housDF$ACCESS))
hDFwModem <- subset(housDF, !is.na(housDF$MODEM))



##Plotting Distribution of Internet Access by Income
ggplot(hDFwAccess, aes(x=ACCESS, y = FINCP, fill = ACCESS)) + 
  geom_boxplot() +
  xlab("Inc") + 
  ## ylab("Count") + 
  ggtitle("Income")



##Plotting Distribution of Internet Access by Income
ggplot(hDFwAccess, aes(x=ACCESS, y = FINCP, fill = ACCESS)) + 
  geom_violin() +
  xlab("Inc") + 
  ## ylab("Count") + 
  ggtitle("Income")





##Plotting Distribution of Internet Access by Income
ggplot(hDFwAccess, aes(FINCP, group = ACCESS)) + 
  geom_histogram(bins = 50, aes( colour = ACCESS, fill = ACCESS), alpha = 0.5) +
  xlab("Inc") + 
  ylab("Count") + 
  ggtitle("Inc by Internet")



##Plotting Distirubtion of Internet Access by Income using 

ggplot(hDFwModem, aes(FINCP, group = MODEM)) + 
  geom_histogram(bins = 50, aes(colour = MODEM, fill = MODEM), alpha = .5) + ## geom_histogram(bins = 50, aes(colour = MODEM, fill = MODEM), alpha = 0.3)
  xlab("Inc") + 
  ylab("Count") + 
  ggtitle("Inc by Internet")