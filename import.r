#!/usr/bin/env Rscript

library(DBI)
library(RMySQL)

rm(list=ls())
setwd("/Users/paulviallard/Universite/M1/S2/Data_Mining/Project/")

# We will use the database lol on MySQL
dataset.conn = dbConnect(MySQL(), dbname="lol", username="root", password="")

dataset.champs = read.csv("Data/champs.csv")
dbWriteTable(dataset.conn, value=dataset.champs, name = "champs") 

dataset.matches = read.csv("Data/matches.csv")
dbWriteTable(dataset.conn, value=dataset.matches, name = "matches") 

dataset.participants = read.csv("Data/participants.csv")
dbWriteTable(dataset.conn, value=dataset.participants, name = "participants")

dataset.stats1 = read.csv("Data/stats1.csv")
dbWriteTable(dataset.conn, value=dataset.stats1, name = "stats")
dataset.stats2 = read.csv("Data/stats2.csv")
dbWriteTable(dataset.conn, value=dataset.stats2, name = "stats", append=TRUE) 

dataset.teambans = read.csv("Data/teambans.csv")
dbWriteTable(dataset.conn, value=dataset.teambans, name = "teambans") 

dataset.teamstats = read.csv("Data/teamstats.csv")
dbWriteTable(dataset.conn, value=dataset.teamstats, name = "teamstats") 
