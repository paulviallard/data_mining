#!/usr/bin/env Rscript

library(DBI)
library(RMySQL)

# The class Dataset represents the datasets
Dataset = R6Class("Dataset", 
  public = list(
    champs = NULL,
    bans = NULL,
    player = NULL,
    team = NULL,
    item = NULL,

    initialize = function(dbname = "lol", username = "root", password = "") {
      # We export the dataset from the MySQL database
      # We create a MySQL connection
      private$conn = dbConnect(MySQL(), dbname=dbname, username = username, password = password)
   
      # If the datasets are not imported in MySQL
      if(!private$is_imported()) {
        # We drop the table in the database
        private$drop_dataset()
        # and we import the dataset of Kaggle
        private$import()
      }
      # We export the dataset
      private$export()
      # and we close the connection
      private$close()
    }
  ),

  private = list(
    conn = NULL,
 
    import = function() {
      # We import the original dataset in MySQL
      # We load champs.csv
      private$get_query("CREATE TABLE champs(id INT AUTO_INCREMENT PRIMARY KEY, name TEXT, row_names TEXT)")
      private$get_query("CREATE INDEX champs_index ON champs (id)")
      champs = private$read("dataset/champs.csv")
      private$write_table(champs, "champs")
      
      # We load matches.csv
      private$get_query("CREATE TABLE matches(id INT AUTO_INCREMENT PRIMARY KEY, gameid INT, platformid TEXT, queueid INT, seasonid INT, duration INT, creation INT, version TEXT, row_names TEXT)")
      private$get_query("CREATE INDEX matches_seasonid_index ON matches (seasonid)")
      private$get_query("CREATE INDEX matches_id_index ON matches (id)")
      matches = private$read("dataset/matches.csv")
      private$write_table(matches, "matches") 

      # We load participants.csv
      private$get_query("CREATE TABLE participants(id INT AUTO_INCREMENT PRIMARY KEY, matchid INT, player INT, championid INT, ss1 INT, ss2 INT, role TEXT, position TEXT, row_names TEXT)")
      private$get_query("CREATE INDEX participants_championid_index ON participants (championid)")
      private$get_query("CREATE INDEX participants_matchid_index ON participants (matchid)")
      private$get_query("CREATE INDEX participants_id_index ON participants (id)")
      participants = private$read("dataset/participants.csv")
      private$write_table(participants, "participants")

      # We load stats.csv
      private$get_query("CREATE TABLE stats(id INT AUTO_INCREMENT PRIMARY KEY, win INT, item1 INT, item2 INT, item3 INT, item4 INT,item5 INT, item6 INT, trinket INT, kills INT,  deaths INT, assists INT, largestkillingspree INT, largestmultikill INT, killingsprees INT, longesttimespentliving INT, doublekills INT, triplekills INT, quadrakills INT, pentakills INT, legendarykills INT, totdmgdealt INT, magicdmgdealt INT, physicaldmgdealt INT, truedmgdealt INT, largestcrit INT, totdmgtochamp INT, magicdmgtochamp INT, physdmgtochamp INT, truedmgtochamp INT, totheal INT, totunitshealed INT, dmgselfmit INT, dmgtoobj INT, dmgtoturrets INT, visionscore INT, timecc INT, totdmgtaken INT, magicdmgtaken INT, physdmgtaken INT, truedmgtaken INT, goldearned INT, goldspent INT, turretkills INT, inhibkills INT, totminionskilled INT, neutralminionskilled INT, ownjunglekills INT, enemyjunglekills INT, totcctimedealt INT, champlvl INT, pinksbought INT, wardsbought INT, wardsplaced INT, wardskilled INT, firstblood INT, row_names TEXT)")
      private$get_query("CREATE INDEX stats_index ON stats (id)")
      stats1 = private$read("dataset/stats1.csv")
      private$write_table(stats1, "stats")
      stats2 = private$read("dataset/stats2.csv")
      private$write_table(stats2, "stats")

      # We load teambans.csv
      private$get_query("CREATE TABLE teambans(matchid INT, teamid INT, championid INT, banturn INT, row_names TEXT)")
      private$get_query("CREATE INDEX teambans_index ON teambans (matchid, teamid)")
      teambans = private$read("dataset/teambans.csv")
      private$write_table(teambans, "teambans") 

      # We load teamstats.csv
      private$get_query("CREATE TABLE teamstats(matchid INT, teamid INT, firstblood INT, firsttower INT, firstinhib INT, firstbaron INT, firstdragon INT, firstharry INT, towerkills INT, inhibkills INT, baronkills INT, dragonkills INT, harrykills INT, row_names TEXT)")
      private$get_query("CREATE INDEX teamstats_index ON teamstats (matchid, teamid)")
      teamstats = private$read("dataset/teamstats.csv")
      private$write_table(teamstats, "teamstats")
    },

    export = function(version = "7.10.187.9675") {
      # We export the dataset from MySQL
      # We export the dataset of the champions
      self$champs = private$read_dataset("dataset/export_champs.csv", paste("SELECT matches.id, stats.win, champs.name FROM matches, participants, champs, stats WHERE matches.id = participants.matchid AND stats.id = participants.id  AND participants.championid = champs.id AND version = '", version, "'", sep=""))
      
      # We export the dataset of the banned champions
      self$bans = private$read_dataset("dataset/export_bans.csv", paste("SELECT matches.id, champs.name FROM matches, teambans, champs WHERE matches.id = teambans.matchid AND teambans.championid = champs.id AND version = '", version, "'", sep=""))

      # We export the item dataset
      self$item = private$read_dataset("dataset/export_item.csv", paste("SELECT stats.win, champs.name, participants.role, participants.position, stats.item1, stats.item2, stats.item3, stats.item4, stats.item5, stats.item6, stats.trinket, participants.ss1, participants.ss2 FROM participants, stats, champs, matches WHERE participants.id = stats.id AND participants.championid = champs.id AND matches.id = participants.matchid AND version = '", version, "'", sep=""))

      # We export the player dataset
      self$player = private$read_dataset("dataset/export_player.csv", paste("SELECT matches.id, win, duration, champs.name, role, position, kills, deaths, assists, largestkillingspree, largestmultikill, killingsprees, longesttimespentliving, doublekills, triplekills, quadrakills, pentakills, totdmgdealt, magicdmgdealt, physicaldmgdealt, truedmgdealt, largestcrit, totdmgtochamp, magicdmgtochamp, physdmgtochamp, truedmgtochamp, totheal, totunitshealed, dmgselfmit, dmgtoobj, dmgtoturrets, visionscore, totdmgtaken, magicdmgtaken, physdmgtaken, truedmgtaken, goldearned, goldspent, turretkills, inhibkills, totminionskilled, neutralminionskilled, ownjunglekills, enemyjunglekills, totcctimedealt, champlvl, pinksbought, wardsplaced, wardskilled, firstblood FROM matches, participants, champs, stats WHERE matches.id = participants.matchid AND participants.championid = champs.id AND stats.id = participants.id AND version = '", version, "'", sep=""))

      # We export the team dataset
      self$team = private$read_dataset("dataset/export_team.csv", paste("SElECT matchid, teamid, firstblood, firsttower, firstinhib, firstbaron, firstdragon, firstharry, towerkills, inhibkills, baronkills, dragonkills, harrykills FROM matches, teamstats WHERE matches.id = teamstats.matchid AND version = '", version, "' ORDER BY matchid ASC, teamid ASC", sep=""))
    },

    is_imported = function() {
      # We check if the original dataset is imported in MySQL
      imported = FALSE
      # We look at the existing tables
      tables = private$get_query("SHOW TABLES")
      tables = c(tables[,1])

      # We check if all the tables are imported
      required_tables = c("champs", "matches", "participants", "stats", "teambans", "teamstats")
      if (length(tables) == length(required_tables) && all(tables == required_tables)) {
        imported = TRUE
      }
      imported
    },

    drop_dataset = function() {
      # We drop all the tables if they exist
      private$get_query("DROP TABLE IF EXISTS champs, matches, participants, stats, teambans, teamstats")
    },

    get_query = function(query) {
      # We execute a query in the MySQL database
      dbGetQuery(private$conn, query)
    },

    write_table = function(dataset, table) {
      # We import a dataframe
      dbWriteTable(private$conn, value=dataset, name = table, append=TRUE)
    },

    read_dataset = function(dataset, query) {
      # If the file of the dataset exists
      if(file.exists(dataset)) {
        # We load in memory the dataset
        data = private$read(dataset)
      } else {
        # Otherwise we do a query on MySQL
        data = private$get_query(query)
        # and we save the dataset
        private$write(data, dataset)
      }
      data
    },

    close = function() {
      # We close the MySQL connection
      dbDisconnect(private$conn)
      # and we set to NULL the object 
      private$conn = NULL
    },

    read = function(path) {
      # We read a dataset if the file exists
      file = NA
      if(file.exists(path)) {
        file = read.csv(path)
      }
      file
    },

    write = function(data, file) {
      # We save in memory the dataset
      write.csv(data, file, row.names=FALSE)
    }
  )
)
