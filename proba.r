#!/usr/bin/env Rscript

library(DBI)
library(RMySQL)
library(ggplot2)
library(reshape2)

rm(list=ls())
setwd("/Users/paulviallard/Universite/M1/S2/Data_Mining/Project/")

dataset.export = function() { 
  if(!file.exists(dataset.file)) {
    conn = dbConnect(MySQL(), dbname="lol", username="root", password="")
    data = dbGetQuery(conn, dataset.query)
    write.csv(data, dataset.file)
  } else {
    data = read.csv(dataset.file)
  }
  data
}

# We export the datasets
dataset.file = "Data/Understanding/proba_champs.csv"
dataset.query = "SELECT matches.id, champs.name FROM matches, participants, champs WHERE matches.id = matchid AND seasonid = 8 AND championid = champs.id"
dataset_champs.data = dataset.export()
head(dataset_champs.data)

dataset.file = "Data/Understanding/proba_bans.csv"
dataset.query = "SELECT matches.id, banturn, teamid, champs.name FROM matches, teambans, champs WHERE matches.id = teambans.matchid AND seasonid = 8 AND championid = champs.id"
dataset_bans.data = dataset.export()
head(dataset_bans.data)

# We compute the frequency of the apparition of the champions
dataset_champs.freq = as.data.frame(table(dataset_champs.data$name))
colnames(dataset_champs.freq) = c("Name", "Freq_Champs")
head(dataset_champs.freq)

# We compute the frequency of bans for the champions
dataset_bans.freq = as.data.frame(table(dataset_bans.data$name))
colnames(dataset_bans.freq) = c("Name", "Freq_Bans")
head(dataset_bans.freq)

# We will merge the two dataframe
dataset_freq.data = merge(dataset_champs.freq, dataset_bans.freq, by="Name")
head(dataset_freq.data)

# We will plot the dataframe
dataset_freq.melt = melt(dataset_freq.data)
ggplot(dataset_freq.melt, aes(x=Name, y=value, fill=variable)) + geom_bar(stat="identity", ) + coord_flip() + theme(legend.text=element_text(size=5)) + theme_bw(base_size=5)
