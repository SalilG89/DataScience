install.packages("twitteR")
library(twitteR)


api_key <- "qZpU3S59CB5fiOXxTXM9ZvRCK"
api_secret <- "GmVIx3fbUzMQwmkS5fntWp2baj0nynI8sE2mEnZjED4pandATE"
access_token_key <- "3974835413-vAm6Mmmcfx2RoTiIwgzNc5r7FMH1vQuvkOqIvKo"
access_token_secret <- "LE7w5YT4tYdcYp6hPZsyUXE4J2iJNDM4IluhqXNSC5pwk"



setup_twitter_oauth(api_key, api_secret, access_token = access_token_key, access_secret = access_token_secret)



mytweets <- searchTwitter('Jon Snow',   n=5000, retryOnRateLimit=1)



class(mytweets)

mtdf <- as.data.frame(mytweets)


getText(mytweets)