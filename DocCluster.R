library(RCurl)
library(XML)
library(tm)
library(ggplot2)
library(reshape2)
install.packages("apcluster")
library(apcluster)
##rm(list = ls())


## get names of plays and genres 

page <- "http://shakespeare.mit.edu/"
tab <- readHTMLTable(page, stringsAsFactors=F)[[2]]
# function to help with the HTML table
unq <- function(i) {
  j <- character(0); k <- character(0)
  j <- unique(unlist(strsplit(i, split = "\n"))) 
  k <- j[j != ""]
  k
}
# data frame of play names by genre
play_names <- apply(tab, 2, unq)
# fix some bad html
play_names$Comedy <- play_names$Comedy[play_names$Comedy != "The"]
# long table of the same
play_names_long <- stack(play_names)
# subset only plays
play_names_long <- play_names_long[play_names_long$ind != "Poetry",]


## get full text of each play
inx_page <- htmlParse(getURI(page))
# get all URLs on the web page
lnk <- unname(xpathSApply(inx_page, "//a/@href"))
# get names of URLs to match the play names in the table above
txt <- sapply(unname(xpathSApply(inx_page, "//a/text()")), xmlValue)  
# put URLs and their names together in a data frame
df <- data.frame(lnk, txt)
# subset df so it's only the plays
df <- df[df$txt %in% play_names_long$values,]
# add genre column to df
df$genre <- play_names_long$ind[match(df$txt, play_names_long$values)]
# edit URLs of plays to get to full text of plays
df$lnk <- gsub("index", "full", df$lnk)
# and now make into complete URLs that we can scrape
df$lnk <- paste0("http://shakespeare.mit.edu/", df$lnk)
# helper function to get all plain text from a full text page (excludes characters' names)
makefulltext <- function(i) paste(sapply(unname(xpathSApply(htmlParse(getURI(i)), "//a/text()")), xmlValue), collapse = " ")
fulltext <- lapply(df$lnk, makefulltext)
names(fulltext) <- df$txt


doc.vec <- VectorSource(fulltext)

doc.corpus <- Corpus(doc.vec)
##summary(doc.corpus)
##doc.corpus <- tm_map(doc.corpus, tolower)
doc.corpus <- tm_map(doc.corpus, removePunctuation)
doc.corpus <- tm_map(doc.corpus, removeNumbers)
doc.corpus <- tm_map(doc.corpus, stripWhitespace)
doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"))

##class(doc.corpus)



dtm <- DocumentTermMatrix(doc.corpus)
# check names
dtm$dimnames$Doc

## do tfxidf
dtm <- weightTfIdf(dtm)
# inspect(dtm[1:10, 5001:5010])



m <- as.matrix(dtm)
rownames(m) <- paste0(df$genre, "_", dtm$dimnames$Doc)

# don't forget to normalize the vectors so Euclidean makes sense
norm_eucl <- function(m) m/apply(m, MARGIN=1, FUN=function(x) sum(x^2)^.5)
m_norm <- norm_eucl(m)

# how many clusters?
d.apclus <- apcluster(negDistMat(r=2), m)
cat("affinity propogation optimal number of clusters:", n <- length(d.apclus@clusters), "\n")

# identify clusters
cl <- kmeans(m_norm, n)



pc <- data.frame(prcomp(m_norm)$x[,1:2])
pc$txt <- dtm$dimnames$Doc
pc$gen <- df$genre
ggplot(pc, aes(PC1, PC2, colour = gen, label = txt)) +
  geom_text() +
  theme_minimal()

