##rm(list = ls())

install.packages('tabplot')

library(ggplot2)

library(tabplot)

library(plotly)


MotorTrendCarsTib <- as_data_frame(mtcars)


MotorTrendCarsTib <- MotorTrendCarsTib %>% mutate(Transmission = as.factor(am))

levels(MotorTrendCarsTib$Transmission) <- c("Automatic", "Manual")



tableplot(MotorTrendCarsTib, select = c(Transmission, mpg, cyl, disp, hp, drat, wt, qsec, vs, gear, carb), sortCol = Transmission)

ggplot(data = MotorTrendCarsTib) + 
  geom_boxplot(mapping = aes(x = Transmission, y = mpg, fill = Transmission))



ggplot(data = MotorTrendCarsTib) + 
  geom_boxplot(mapping = aes(x = Transmission, y = mpg, fill = Transmission))
ggplotly()


MotorTrendCarsTib %>% group_by(Transmission) %>% summarise(TransmissionAvg = mean(mpg))



fit1 <- lm(mpg ~ am, data = MotorTrendCarsTib)
coef(summary(fit1))
