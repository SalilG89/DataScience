library(data.table)
library(ggplot2)
install.packages("Vennerable", repos = "http://R-Forge.R-project.org")
source("https://bioconductor.org/biocLite.R")
biocLite("RBGL")
library(tabplot)

install.packages("RBGL", repos="http://cran.r-project.org")
library(vennerable)

library(choroplethr)
library(choroplethrMaps)


popCols <- c( "ST", "PWGTP", "AGEP" ,"CIT", "CITWP", "COW", "DEAR", "DEYE", "ENG", "MAR" ,  "SCH", "SCHG", "SEX", "WAGP", "ANC1P", "POBP" ,"VPS", "ESR", "PINCP")

##ST STate


##CITIZENSHIP
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



levels(popDF$CIT) <- c("Born in US", "Born in US Terri", "American Born abroad", "Naturalized", "Non-Citizen")

levels(popDF$COW) <- c("For-Profit" , "Non-Proft", "Local Gov", "State Gov", "Fed Gov", "Self-Employed A", "Self-Employed B", "Without Income - Family Biz or Farm", "Unemployed")

levels(popDF$ENG) <- c("Very Well", "Well", "Not Well", "None")

levels(popDF$MAR) <- c("Married", "Widowed", "Divorced", "Seperated", "Never Married or under 15")
levels(popDF$SCH) <- c("No", "Yes Public", "Yes Private")
levels(popDF$SEX) <- c("Male", "Female")
levels(popDF$ESR) <- c("Civilian, at work", "Civilian, Not at Work", "Unemployed", "Armed Forces, at work", "Armed Forces, Not at work", "Non-Labor Force")






levels(popDF$ST) <-    c("alabama", "alaska", "arizona", "arkansas", "california", "colorado", "connecticut",
                         "delaware", "district of columbia", "florida", "georgia", "hawaii", "idaho", "illinois",
                         "indiana", "iowa", "kansas", "kentucky", "louisiana", "maine", "maryland", "massachusetts",
                         "michigan", "minnesota", "mississippi", "missouri", "montana", "nebraska", "nevada",
                         "new hampshire", "new jersey", "new mexico", "new york", "north carolina", "north dakota",
                         "ohio", "oklahoma", "oregon", "pennsylvania", "rhode island",
                         "south carolina", "south dakota", "tennessee", "texas", "utah", "vermont", "virginia",
                         "washington", "west virginia", "wisconsin", "wyoming", "puerto rico")













