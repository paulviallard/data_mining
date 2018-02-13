#!/usr/bin/env Rscript

library(DBI)
library(RMySQL)

dataset.debug = function(data) {
  print("Debug: we exported the dataset")
  print(head(data))
}

dataset.export = function() { 
  if(!file.exists(dataset.file)) {
    conn = dbConnect(MySQL(), dbname="lol", username="root", password="")
    data = dbGetQuery(conn, dataset.query)
    write.csv(data, dataset.file, row.names=FALSE)
  } else {
    data = read.csv(dataset.file)
  }
  data
}

# We export the datasets
dataset.file = "Data/Understanding/proba_champs.csv"
dataset.query = "SELECT matches.id, champs.name FROM matches, participants, champs WHERE matches.id = matchid AND seasonid = 8 AND championid = champs.id"
dataset_champs.data = dataset.export()
dataset.debug(dataset_champs.data)


dataset.file = "Data/Understanding/proba_bans.csv"
dataset.query = "SELECT matches.id, banturn, teamid, champs.name FROM matches, teambans, champs WHERE matches.id = teambans.matchid AND seasonid = 8 AND championid = champs.id"
dataset_bans.data = dataset.export()
dataset.debug(dataset_bans.data)

dataset.file = "Data/Understanding/proba_big_stats.csv"
dataset.query = "SELECT champs.name, trinket, kills, deaths, assists, largestkillingspree, largestmultikill, killingsprees, longesttimespentliving, doublekills, triplekills, quadrakills, pentakills, legendarykills, totdmgdealt, magicdmgdealt, physicaldmgdealt, truedmgdealt, largestcrit, totdmgtochamp, magicdmgtochamp, physdmgtochamp, truedmgtochamp, totheal, totunitshealed, dmgselfmit, dmgtoobj, dmgtoturrets, visionscore, timecc, totdmgtaken, magicdmgtaken, physdmgtaken, truedmgtaken, goldearned, goldspent, turretkills, inhibkills, totminionskilled, neutralminionskilled, ownjunglekills, enemyjunglekills, totcctimedealt, champlvl, pinksbought, wardsbought, wardsplaced, wardskilled, firstblood FROM matches, participants, champs, stats WHERE matches.id = participants.matchid AND participants.championid = champs.id AND stats.id = participants.id AND seasonid = 8"
dataset_stats.data = dataset.export()
dataset_stats.data = na.omit(dataset_stats.data)
dataset.debug(dataset_stats.data)
