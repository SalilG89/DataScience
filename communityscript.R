library(data.table)
library(ggplot2)




popCols <- c("ST", "PWGTP", "AGEP" ,"CIT", "CITWP", "COW", "DEAR", "DEYE", "ENG", "MAR" ,  "SCH", "SCHG", "SEX", "WAGP", "ANC1P", "POBP" ,"VPS", "ESR")

##ST STate
CITIZENSHIP
##Year of naturalizaiton Right in 
##CLASS OF WORKER
##HEARING DIFFICULTY
## SEEING DIFFICULTY
##ENGLISH SPEAKING
##MARITUAL STATUS
##SCHOOL ENROLLMENT
##GRADE LEVEL ATTENDING
##SCHL EDUCATIONAL ATTAINMENT
##GENDER
##SALARY IN PAST 12 MONTHS
##ANC1P DETAILED ANCESTRY
##POBP Place of Birth
##EMPLOYMENTSTATUSReCODE

popDF <- fread("H:\\Py\\csv_pus\\ss13pusa.csv", select  = popCols)


popDF$ST <- factor(popDF$ST)
popDF$CIT <- factor(popDF$CIT)
popDF$COW <- factor(popDF$COW)
popDF$DEAR <- factor(popDF$DEAR)
popDF$DEYE <- factor(popDF$DEYE)
popDF$ENG <- factor(popDF$ENG)
popDF$MAR <- factor(popDF$MAR)
popDF$RETP <- factor(popDF$RETP)
popDF$SCH <- factor(popDF$SCH)
popDF$SCHG <- factor(popDF$SCHG)
popDF$SEX <- factor(popDF$SEX)
popDF$ESR <- factor(popDF$ESR)
popDF$POBP <- factor(popDF$POBP)
popDF$VPS <- factor(popDF$VPS)

###### housing analsis below

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
ggplot(hDFwAccess, aes(FINCP, group = ACCESS)) + 
  geom_histogram(bins = 50, aes(colour = ACCESS, fill = ACCESS), alpha = 0.3) +
  xlab("Inc") + 
  ylab("Count") + 
  ggtitle("Inc by Internet")



##Plotting Distirubtion of Internet Access by Income using 

ggplot(housDF, aes(FINCP, group = MODEM)) + 
  geom_histogram(bins = 50, aes(colour = MODEM, fill = MODEM), alpha = 0.3) + geom_histogram(bins = 50, aes(colour = MODEM, fill = MODEM), alpha = 0.3)
xlab("Inc") + 
  ylab("Count") + 
  ggtitle("Inc by Internet")