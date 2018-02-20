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
    dbDisconnect(conn)
    write.csv(data, dataset.file, row.names=FALSE)
  } else {
    data = read.csv(dataset.file)
  }
  data
}

# We export the datasets
dataset.file = "Data/Understanding/proba_champs.csv"
dataset.query = "SELECT matches.id, champs.name FROM matches, participants, champs WHERE matches.id = matchid AND version = '7.10.187.9675' AND championid = champs.id"
dataset_champs.data = dataset.export()
dataset.debug(dataset_champs.data)


dataset.file = "Data/Understanding/proba_bans.csv"
dataset.query = "SELECT matches.id, banturn, teamid, champs.name FROM matches, teambans, champs WHERE matches.id = teambans.matchid AND version = '7.10.187.9675' AND championid = champs.id"
dataset_bans.data = dataset.export()
dataset.debug(dataset_bans.data)

dataset.file = "Data/Understanding/proba_player_stats.csv"
dataset.query = "SELECT matches.id, win, duration, champs.name, role, position, trinket, kills, deaths, assists, largestkillingspree, largestmultikill, killingsprees, longesttimespentliving, doublekills, triplekills, quadrakills, pentakills, legendarykills, totdmgdealt, magicdmgdealt, physicaldmgdealt, truedmgdealt, largestcrit, totdmgtochamp, magicdmgtochamp, physdmgtochamp, truedmgtochamp, totheal, totunitshealed, dmgselfmit, dmgtoobj, dmgtoturrets, visionscore, totdmgtaken, magicdmgtaken, physdmgtaken, truedmgtaken, goldearned, goldspent, turretkills, inhibkills, totminionskilled, neutralminionskilled, ownjunglekills, enemyjunglekills, totcctimedealt, champlvl, pinksbought, wardsplaced, wardskilled, firstblood FROM matches, participants, champs, stats WHERE matches.id = participants.matchid AND participants.championid = champs.id AND stats.id = participants.id AND version = '7.10.187.9675'"
dataset_player_stats.data = dataset.export()
dataset.debug(dataset_player_stats.data)

dataset.file = "Data/Understanding/proba_team_stats.csv"
dataset.query = "SElECT matchid, teamid, firstblood, firsttower, firstinhib, firstbaron, firstdragon, firstharry, towerkills, inhibkills, baronkills, dragonkills, harrykills FROM matches, teamstats WHERE matches.id = teamstats.matchid AND version = '7.10.187.9675' ORDER BY matchid ASC, teamid ASC"
dataset_team_stats.data = dataset.export()
dataset.debug(dataset_team_stats.data)

dataset.file = "Data/Understanding/proba_role.csv"
dataset.query = "SELECT champs.name, role, position FROM matches, participants, champs WHERE matches.id = matchid AND version = '7.10.187.9675' AND championid = champs.id"
dataset_role.data = dataset.export()
dataset.debug(dataset_role.data)

dataset.file = "Data/Understanding/proba_basket.csv"
dataset.query = "SELECT matches.id, stats.win, champs.name FROM matches, participants, champs, stats WHERE matches.id = participants.matchid AND stats.id = participants.id  AND participants.championid = champs.id AND version = '7.10.187.9675'"
dataset_basket.data = dataset.export()
dataset.debug(dataset_basket.data)

dataset.file = "Data/Understanding/proba_ban_basket.csv"
dataset.query = "SELECT matches.id, champs.name FROM matches, teambans, champs WHERE matches.id = teambans.matchid AND teambans.championid = champs.id AND version = '7.10.187.9675'"
dataset_ban_basket.data = dataset.export()
dataset.debug(dataset_ban_basket.data)
