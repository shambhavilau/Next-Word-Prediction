library(stringi)
library(tm)
library(dplyr)
library(stringr)
library(quanteda)
library(data.table)

# Load Dataset
twit_data <- read.delim("en_US.twitter.txt",skipNul = TRUE,sep = "")
news_data <- read.delim("en_US.news.txt",skipNul = TRUE,sep = "",header = FALSE)
blog_data <- read.delim("en_US.blogs.txt",skipNul = TRUE,sep = "",header = FALSE)

# Check dimensions of data
dim(twit_data)
dim(news_data)
dim(blog_data)

# Read data from files
twitter_con <- file("en_US.twitter.txt", "r") 
twitter_text<- readLines(twitter_con, encoding = "UTF-8",skipNul = TRUE)
news_con <- file("en_US.news.txt", "r") 
news_text<- readLines(news_con, encoding = "UTF-8",skipNul = TRUE)
blog_con <- file("en_US.blogs.txt", "r") 
blog_text<- readLines(blog_con, encoding = "UTF-8",skipNul = TRUE)


# # count number of lines in each file
num_lines_file <- sapply(list(blog_text, news_text, twitter_text), length)

# count the number of words in each file
num_words_file <- sapply(list(blog_text, news_text, twitter_text), stri_stats_latex)[4,]

# count number of characters in each file
num_chars_file <- sapply(list(nchar(blog_text), nchar(news_text), nchar(twitter_text)), sum)

# summarize above information
files_summary <- data.frame(
  filename = c("en_US.blogs.txt","en_US.news.txt", "en_US.twitter.txt"),
  lines = num_lines_file,
  words = num_words_file,
  characters = num_chars_file
)

Sampled_text <- function(textbody, portion) {
  taking <- sample(1:length(textbody), length(textbody)*portion)
  Sampled_text <- textbody[taking]
  Sampled_text
}

set.seed(32324)
portion <- 1/50

Sampled_Twitter <- Sampled_text(twitter_text, portion)
Sampled_Blog <- Sampled_text(blog_text, portion)
Sampled_News <- Sampled_text(news_text, portion)

Sampled_File <- c(Sampled_Blog, Sampled_News, Sampled_Twitter)

writeLines(Sampled_File, "E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Sampled_File.txt")


cleansing <- function (text_input) {
  text_input <-tolower(text_input)
  
  text_input <-removeWords(text_input,stopwords('en'))
  
  text_input <-removePunctuation(text_input)
  
  text_input <-stripWhitespace(text_input)
  
  return(text_input)
}

Output_Folder <- VCorpus(DirSource("E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output", encoding = "UTF-8"))
wd <- "E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/"

cleansing(Output_Folder)

Ngram_Tokernizer <- function (text_input, n) {
  NgramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = n, max = n))}
  Ngram_Tokernizer <- TermDocumentMatrix(text_input, control = list(tokenizer = NgramTokenizer))
  Ngram_Tokernizer
}

# n gram tokenizer

ngram_sorted_df <- function (Ngram_Tokernizer) {
  tdm_ngram_m <- as.matrix(Ngram_Tokernizer)
  tdm_ngram_df <- as.data.frame(tdm_ngram_m)
  colnames(tdm_ngram_df) <- "Count"
  tdm_ngram_df <- tdm_ngram_df[order(-tdm_ngram_df$Count), , drop = FALSE]
  tdm_ngram_df
}

library(R.utils)
library(dplyr)
library(parallel)
library(tm)
library(ggplot2)
library(RWeka)
library(wordcloud)


#Calculate N-Grams
tdm_1gram <- Ngram_Tokernizer(Output_Folder, 1)
tdm_2gram <- Ngram_Tokernizer(Output_Folder, 2)
tdm_3gram <- Ngram_Tokernizer(Output_Folder, 3)
tdm_4gram <- Ngram_Tokernizer(Output_Folder, 4)

# Extract term-count tables from N-Grams and sort 
tdm_1gram_df <- ngram_sorted_df(tdm_1gram)
tdm_2gram_df <- ngram_sorted_df(tdm_2gram)
tdm_3gram_df <- ngram_sorted_df(tdm_3gram)
tdm_4gram_df <- ngram_sorted_df(tdm_4gram)


# Save data frames into r-compressed files

quadgram <- data.frame(rows=rownames(tdm_4gram_df),count=tdm_4gram_df$Count)
quadgram$rows <- as.character(quadgram$rows)
quadgram_split <- strsplit(as.character(quadgram$rows),split=" ")
quadgram <- transform(quadgram,first = sapply(quadgram_split,"[[",1),second = sapply(quadgram_split,"[[",2),third = sapply(quadgram_split,"[[",3), fourth = sapply(quadgram_split,"[[",4))
quadgram <- data.frame(unigram = quadgram$first,bigram = quadgram$second, trigram = quadgram$third, quadgram = quadgram$fourth, freq = quadgram$count,stringsAsFactors=FALSE)
write.csv(quadgram[quadgram$freq > 1,],"E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/quadgram.csv",row.names=F)
quadgram <- read.csv("E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/quadgram.csv",stringsAsFactors = F)
saveRDS(quadgram,"E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/quadgram.RData")


trigram <- data.frame(rows=rownames(tdm_3gram_df),count=tdm_3gram_df$Count)
trigram$rows <- as.character(trigram$rows)
trigram_split <- strsplit(as.character(trigram$rows),split=" ")
trigram <- transform(trigram,first = sapply(trigram_split,"[[",1),second = sapply(trigram_split,"[[",2),third = sapply(trigram_split,"[[",3))
trigram <- data.frame(unigram = trigram$first,bigram = trigram$second, trigram = trigram$third, freq = trigram$count,stringsAsFactors=FALSE)
write.csv(trigram[trigram$freq > 1,],"E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/trigram.csv",row.names=F)
trigram <- read.csv("E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/trigram.csv",stringsAsFactors = F)
saveRDS(trigram,"E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/trigram.RData")


bigram <- data.frame(rows=rownames(tdm_2gram_df),count=tdm_2gram_df$Count)
bigram$rows <- as.character(bigram$rows)
bigram_split <- strsplit(as.character(bigram$rows),split=" ")
bigram <- transform(bigram,first = sapply(bigram_split,"[[",1),second = sapply(bigram_split,"[[",2))
bigram <- data.frame(unigram = bigram$first,bigram = bigram$second,freq = bigram$count,stringsAsFactors=FALSE)
write.csv(bigram[bigram$freq > 1,],"E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/bigram.csv",row.names=F)
bigram <- read.csv("E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/bigram.csv",stringsAsFactors = F)
saveRDS(bigram,"E:/personal/Learning/Data Science Preparation/Module 10 Capstone/Coursera-SwiftKey/final/en_US/SwiftKeyDataPrediction/Output/bigram.RData")







