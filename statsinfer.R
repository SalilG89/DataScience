set.seed(6969)

lambda <- 0.2

NoOfSimulations <- 1000

NoOfSamples <- 40




Exp_Replications <- replicate(NoOfSimulations, rexp(NoOfSamples, lambda))


Simulated_Means <- apply(Exp_Replications, 2, mean)


hist(Simulated_Means, breaks = 40, col = "cornflowerblue")

SimulatedMean <- mean(Simulated_Means)












library(ggplot2)
library(reshape2)
df <- data.frame(country=c('USA','Brazil','Ghana','England','Australia'), Stabbing=c(15,10,9,6,7), Accidents=c(20,25,21,28,15), Suicide=c(3,10,7,8,6))
mm <- melt(df, id.vars='country')
ggplot(mm, aes(x=country, y=value)) + geom_bar(stat='identity') + facet_grid(.~variable) + coord_flip() + labs(x='',y='')
