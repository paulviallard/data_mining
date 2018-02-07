#!/usr/bin/env Rscript

library(DBI)
library(RMySQL)

rm(list=ls())
setwd("/Users/paulviallard/Universite/M1/S2/Data_Mining/Project/")

# We will use the database lol on MySQL
dataset.conn = dbConnect(MySQL(), dbname="lol", username="root", password="")

# We load champs.csv
dbGetQuery(dataset.conn, "CREATE TABLE champs(
  id INT AUTO_INCREMENT PRIMARY KEY, 
  name TEXT, 
  row_names TEXT)")
dbGetQuery(dataset.conn, "CREATE INDEX champs_index ON champs (id)")
dataset.champs = read.csv("Data/champs.csv")
dbWriteTable(dataset.conn, value=dataset.champs, name = "champs", append=TRUE) 

# We load matches.csv
dbGetQuery(dataset.conn, "CREATE TABLE matches(
  id INT AUTO_INCREMENT PRIMARY KEY, 
  gameid INT, 
  platformid TEXT,
  queueid INT,
  seasonid INT,
  duration INT,
  creation INT,
  version TEXT, 
  row_names TEXT)")
dbGetQuery(dataset.conn, "CREATE INDEX matches_seasonid_index ON matches (seasonid)")
dbGetQuery(dataset.conn, "CREATE INDEX matches_id_index ON matches (id)")
dataset.matches = read.csv("Data/matches.csv")
dbWriteTable(dataset.conn, value=dataset.matches, name = "matches", append=TRUE) 

# We load participants.csv
dbGetQuery(dataset.conn, "CREATE TABLE participants(
  id INT AUTO_INCREMENT PRIMARY KEY, 
  matchid INT, 
  player INT,
  championid INT,
  ss1 INT,
  ss2 INT,
  role INT,
  position TEXT, 
  row_names TEXT)")
dbGetQuery(dataset.conn, "CREATE INDEX participants_championid_index ON participants (championid)")
dbGetQuery(dataset.conn, "CREATE INDEX participants_matchid_index ON participants (matchid)")
dbGetQuery(dataset.conn, "CREATE INDEX participants_id_index ON participants (id)")
dataset.participants = read.csv("Data/participants.csv")
dbWriteTable(dataset.conn, value=dataset.participants, name = "participants", append=TRUE)

# We load stats.csv
dbGetQuery(dataset.conn, "CREATE TABLE stats(
  id INT AUTO_INCREMENT PRIMARY KEY, 
  win INT,
  item1 INT,
  item2 INT,
  item3 INT,
  item4 INT,
  item5 INT,
  item6 INT,
  trinket INT,
  kills INT, 
  deaths INT,
  assists INT,
  largestkillingspree INT,
  largestmultikill INT,
  killingsprees INT,
  longesttimespentliving INT,
  doublekills INT,
  triplekills INT,
  quadrakills INT,
  pentakills INT,
  legendarykills INT,
  totdmgdealt INT,
  magicdmgdealt INT,
  physicaldmgdealt INT,
  truedmgdealt INT,
  largestcrit INT,
  totdmgtochamp INT,
  magicdmgtochamp INT,
  physdmgtochamp INT, 
  truedmgtochamp INT, 
  totheal INT,
  totunitshealed INT,
  dmgselfmit INT,
  dmgtoobj INT,
  dmgtoturrets INT,
  visionscore INT,
  timecc INT,
  totdmgtaken INT,
  magicdmgtaken INT,
  physdmgtaken INT,
  truedmgtaken INT,
  goldearned INT,
  goldspent INT,
  turretkills INT,
  inhibkills INT,
  totminionskilled INT,
  neutralminionskilled INT,
  ownjunglekills INT,
  enemyjunglekills INT,
  totcctimedealt INT,
  champlvl INT,
  pinksbought INT,
  wardsbought INT,
  wardsplaced INT,
  wardskilled INT,
  firstblood INT,
  row_names TEXT)")
dbGetQuery(dataset.conn, "CREATE INDEX stats_index ON stats (id)")
dataset.stats1 = read.csv("Data/stats1.csv")
dbWriteTable(dataset.conn, value=dataset.stats1, name = "stats", append=TRUE)
dataset.stats2 = read.csv("Data/stats2.csv")
dbWriteTable(dataset.conn, value=dataset.stats2, name = "stats", append=TRUE) 

# We load teambans.csv
dbGetQuery(dataset.conn, "CREATE TABLE teambans(
  matchid INT, 
  teamid INT,
  championid INT,
  banturn INT,
  row_names TEXT)")
dbGetQuery(dataset.conn, "CREATE INDEX teambans_index ON teambans (matchid, teamid)")
dataset.teambans = read.csv("Data/teambans.csv")
dbWriteTable(dataset.conn, value=dataset.teambans, name = "teambans", append=TRUE) 

# We load teamstats.csv
dbGetQuery(dataset.conn, "CREATE TABLE teamstats(
  matchid INT, 
  teamid INT,
  firstblood INT,
  firsttower INT,
  firstinhib INT,
  firstbaron INT,
  firstdragon INT,
  firstharry INT,
  towerkills INT,
  inhibkills INT,
  baronkills INT,
  dragonkills INT,
  harrykills INT,
  row_names TEXT)")
dbGetQuery(dataset.conn, "CREATE INDEX teamstats_index ON teamstats (matchid, teamid)")
dataset.teamstats = read.csv("Data/teamstats.csv")
dbWriteTable(dataset.conn, value=dataset.teamstats, name = "teamstats", append=TRUE) 
