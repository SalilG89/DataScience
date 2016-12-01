##rm(list = ls())

install.packages('tabplot')

library(ggplot2)

library(tabplot)

ToothGrowthT <- as_data_frame(ToothGrowth)


ToothGrowthT<- ToothGrowthT %>% mutate(doseFactor = as.factor(as.character(dose)))

summary(ToothGrowthT)



ggplot(data = ToothGrowthT) + 
  geom_boxplot(mapping = aes(x = supp, y = len, fill = supp))



ggplot(data = ToothGrowthT) + 
  geom_boxplot(mapping = aes(x = doseFactor, y = len, fill = doseFactor))

tableplot(ToothGrowthT, select = c(dose, supp, len), sortCol = dose)


ggplot(aes(x = supp, y = len), data = ToothGrowth) +
  geom_boxplot(aes(fill = supp)) + facet_wrap(~ dose)

ggplot(data = ToothGrowthT, aes(x = doseFactor, y = len)) +
  geom_boxplot(aes(fill = doseFactor)) + facet_wrap(~ supp)

ToothGrowthT %>% group_by(supp) %>% summarise(lenAvg = mean(len))
ToothGrowthT %>% group_by(dose) %>% summarise(lenAvg = mean(len))
ToothGrowthT %>% group_by(supp, dose) %>% summarise(lenAvg = mean(len))

toothgrowth.OJ <- ToothGrowthT %>% filter(supp == "OJ")  %>% select(len)
toothgrowth.VC <- ToothGrowthT %>% filter(supp == "VC")   %>% select(len)

toothgrowth.OJ.DoseTwo <- ToothGrowthT %>% filter(supp == "OJ" & dose == "2")  %>% select(len)
toothgrowth.VC.DoseTwo <- ToothGrowthT %>% filter(supp == "VC" & dose == "2")   %>% select(len)

##ToothGrowthT %>% select(dose) %>% distinct(dose)


##Two-tailed independent t-test with unequal variance.

t.test(toothgrowth.OJ$len, toothgrowth.VC$len, alternative = "two.sided", paired = FALSE, var.equal = FALSE, conf.level = 0.95)


##Two-tailed t-test for subset where dose = 2.0



t.test(toothgrowth.OJ.DoseTwo$len, toothgrowth.VC.DoseTwo$len, alternative = "two.sided", paired = FALSE, var.equal = FALSE, conf.level = 0.95)