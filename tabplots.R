library(ggplot2)
install.packages("tabplot")
library(tabplot)



MedMaldata <- read.csv("C:/Users/20165/Desktop/medmaldata.csv", header = TRUE)

tableplot(MedMaldata, sortCol = InjurySeverityCodeId)
data(diamonds)
#run ?diamonds for more information on the dataset
tableplot(diamonds)
#sort by depth
tableplot(diamonds, sortCol=depth)




MedMaldata <- read.csv("C:/Users/20165/Desktop/medmaldata.csv", header = TRUE)

tableplot(MedMaldata, sortCol = InjurySeverityCodeId)