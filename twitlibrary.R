install.packages("twitteR")
library(twitteR)
library(tm)
library(syuzhet)
library(wordcloud)
library(devtools)
if (!require("pacman")) install.packages("pacman")
install_url("http://cran.r-project.org/src/contrib/Archive/Rstem/Rstem_0.4-1.tar.gz")
install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz")


library(sentiment)

api_key <- "qZpU3S59CB5fiOXxTXM9ZvRCK"
api_secret <- "GmVIx3fbUzMQwmkS5fntWp2baj0nynI8sE2mEnZjED4pandATE"
access_token_key <- "3974835413-vAm6Mmmcfx2RoTiIwgzNc5r7FMH1vQuvkOqIvKo"
access_token_secret <- "LE7w5YT4tYdcYp6hPZsyUXE4J2iJNDM4IluhqXNSC5pwk"



setup_twitter_oauth(api_key, api_secret, access_token = access_token_key, access_secret = access_token_secret)



mytweets <- searchTwitter('Jon Snow',   n=500, retryOnRateLimit=1)




some_txt <- sapply(mytweets, function(x) x$getText())

some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
# remove at people
some_txt = gsub("@\\w+", "", some_txt)
# remove punctuation
some_txt = gsub("[[:punct:]]", "", some_txt)
# remove numbers
some_txt = gsub("[[:digit:]]", "", some_txt)
# remove html links
some_txt = gsub("http\\w+", "", some_txt)
# remove unnecessary spaces
some_txt = gsub("[ \t]{2,}", "", some_txt)
some_txt = gsub("^\\s+|\\s+$", "", some_txt)


# define "tolower error handling" function
try.error = function(x)
{
  # create missing value
  y = NA
  # tryCatch error
  try_error = tryCatch(tolower(x), error=function(e) e)
  # if not an error
  if (!inherits(try_error, "error"))
    y = tolower(x)
  # result
  return(y)
}
# lower case using try.error with sapply
some_txt = sapply(some_txt, try.error)

# remove NAs in some_txt
some_txt = some_txt[!is.na(some_txt)]
names(some_txt) = NULL

# Perform Sentiment Analysis
# classify emotion
class_emo = classify_emotion(some_txt, algorithm="bayes", prior=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by "unknown"
emotion[is.na(emotion)] = "unknown"

# classify polarity
class_pol = classify_polarity(some_txt, algorithm="bayes")
# get polarity best fit
polarity = class_pol[,4]
# Create data frame with the results and obtain some general statistics
# data frame with results
sent_df = data.frame(text=some_txt, emotion=emotion,
                     polarity=polarity, stringsAsFactors=FALSE)

# sort data frame
sent_df = within(sent_df,  emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))

emos = levels(factor(sent_df$emotion))
nemo = length(emos)
emo.docs = rep("", nemo)
for (i in 1:nemo)
{
  tmp = some_txt[emotion == emos[i]]
  emo.docs[i] = paste(tmp, collapse=" ")
}

# remove stopwords
emo.docs = removeWords(emo.docs, stopwords("english"))
# create corpus
corpus = Corpus(VectorSource(emo.docs))
tdm = TermDocumentMatrix(corpus)
tdm = as.matrix(tdm)
colnames(tdm) = emos

summary(tdm)

# comparison word cloud
comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"), scale = c(3,.5), random.order = FALSE, title.size = 1.5)

png("EyesWideOpen.png", width=12, height=8, units="in", res=300)
comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"), scale = c(3,.5), random.order = FALSE, title.size = 1.5)
dev.off()




#################################################

myVectorSource <- VectorSource(text)

myCorpus <- Corpus(myVectorSource)
myFreqMatrix <- as.matrix(TermDocumentMatrix(myCorpus))

word_freqs = sort(rowSums(myFreqMatrix), decreasing = TRUE)

myclouddf <- data.frame(word = names(word_freqs), freq = word_freqs)



png(pngloc, width=12, height=8, units="in", res=300)
wordcloud(myclouddf$word, myclouddf$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
