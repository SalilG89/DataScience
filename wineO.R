library(scatterplot3d)

library(rpart)
library(rattle)
library(RColorBrewer)
library(rpart.plot)
library(caret)
library(dplyr)
library(sqldf)

redURL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"
whiteURL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"


redDF <- read.csv(redURL, sep = ";")


whiteDF <- read.csv(whiteURL, sep = ";")

whiteDF$Color <- "White"
redDF$Color <- "Red"

wineDF <- rbind(whiteDF, redDF)
wineDF$Color <- as.factor(wineDF$Color)


##summary(wineDF)


##str(wineDF)

##pairs(wineDF[,1:12])

##colnames(wineDF)
##colors <- c("Green", "Purple")
##colors <- colors[as.numeric(wineDF$Color)]


##scatterplot3d(x = wineDF$residual.sugar, y = wineDF$sulphates, wineDF$total.sulfur.dioxide, color = colors)




ggplot(aes(x=density,y=pH,color=Color),data=wineDF)+geom_jitter() + ggtitle("Density vs Acidity")+xlab("Density") + ylab("pH") + scale_color_manual(values = colors)



ggplot(aes(x=residual.sugar,y=total.sulfur.dioxide ,color=Color),data=wineDF)+geom_jitter() + ggtitle("Density vs Acidity")+xlab("Density") + ylab("pH") + scale_color_manual(values = colors)





wineformula <- formula(Color ~ fixed.acidity + volatile.acidity + citric.acid +
                         residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol + quality)





rprimindex <- createDataPartition(y=wineDF$Color, times = 1, p =.5, list = F)
wineDFtrain <-wineDF[rprimindex, ] ## Create Test Data
wineDFtest  <-wineDF[-rprimindex, ]

winemodel <- rpart(wineformula, data = wineDFtrain)




winePredtest <-as.data.frame(predict(winemodel,wineDFtest))

##head(winePredtest)





ColorRecode<- sqldf(  " select case when White > .5 then 'White'
  when Red > .5 then 'Red'
  end as Color from winePredtest")




winePredtest$Color <- as.factor(ColorRecode$Color)


str(ColorRecode)


##levels(winePredtest$Color) <- c("Red", "White")
##confusionMatrix(winePredtest$Color, wineDFtest$Color)

levels(wineDFtest$Color)

##fancyRpartPlot(winemodel)