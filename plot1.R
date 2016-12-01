NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##library(ggplot2)





##Plot 1



aggTotals <- aggregate(Emissions ~ year,NEI, sum)
barplot(
  (aggTotals$Emissions)/10^3,
  names.arg = aggTotals$year,
  xlab = "Year",
  ylab = "PM2.5 Emissions (Kilo Tons)",
  main = "Total PM2.5 Emissions From All US Sources"
)