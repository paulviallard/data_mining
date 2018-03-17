#!/usr/bin/env Rscript

DatasetStats = R6Class("DatasetStats",
  inherit = Dataset,
  public = list(
    stats = NULL,
    stats_label = NULL,
    sample = NULL,

    train = NULL,
    validation = NULL,
    test = NULL,

    train_label = NULL,
    validation_label = NULL,
    test_label = NULL,

    initialize = function(dataset = NULL, seed=0, dbname = "lol", username = "root", password = "") {
      # We export the statistics datasets
      private$seed = seed
      # If the dataset is NULL then we have to create one
      if(is.null(dataset)) {
        super$initialize(dbname, username, password)
      } else {
        # If we have a dataset, we can just set the variables
        self$champs = dataset$champs
        self$bans = dataset$bans
        self$player = dataset$player
        self$team = dataset$team
      }
      # We export the dataset
      self$stats = private$export()
      # and we set the labels 
      self$stats_label = self$stats[,"win"]
      self$stats[,"win"] = NULL

      # We export also the sample
      private$export_split()
    }
  ),

  private = list(
    seed=NULL,

    export = function() {
      # We will compute the dataset

      # If the dataset doesn't exist we will create it
      if(!file.exists("dataset/export_stats.csv")) {
    
        # We compute the two datasets
        stats_player = private$export_player()
        stats_team = private$export_team()
    
        # We merge it
        stats = merge(stats_player, stats_team, by="id")
    
        # The name of the rows will be the id
        row.names(stats) = stats[,"id"]
        stats[,"id"] = NULL

        # We remove the NA data
        stats = na.omit(stats)

        # And we export it
        private$write(stats, "dataset/export_stats.csv")
      } else {
        # If we have the file, we can import it
        stats = private$read("dataset/export_stats.csv")
      }
      # We return the new dataset
      stats
    },

    export_player = function() {
      # The function will create a dataset with all the columns corresponding to all roles of a team and with the two teams

      # We remove some shared columns
      column = colnames(self$player)
      column_without = c("id", "win", "duration", "name", "role", "position")
      column = column[! column %in% column_without]

      # We create the columns for the top
      column_top = lapply(column, function(x) { paste(x, "_top", sep="") })
      column_top = unlist(column_top)

      # We create the columns for the mid
      column_mid = lapply(column, function(x) { paste(x, "_mid", sep="") })
      column_mid = unlist(column_mid)

      # We create the columns for the jungle
      column_jungle = lapply(column, function(x) { paste(x, "_jungle", sep="") })
      column_jungle = unlist(column_jungle)

      # We create the columns for the support
      column_supp = lapply(column, function(x) { paste(x, "_supp", sep="") })
      column_supp = unlist(column_supp)

      # We create the columns for the AD Carry
      column_carry = lapply(column, function(x) { paste(x, "_carry", sep="") })
      column_carry = unlist(column_carry)

      # We create the columns with all the roles for the two teams
      column_team1 = c(column_top, column_mid, column_jungle, column_supp, column_carry)
      column_team2 = column_team1

      # We rename the columns for the first and the second team
      column_team1 = lapply(column_team1, function(x) { paste(x, "_1", sep="") })
      column_team2 = lapply(column_team2, function(x) { paste(x, "_2", sep="") })
      column_team1 = unlist(column_team1)
      column_team2 = unlist(column_team2)

      # We create a new dataframe which will be our dataset
      number_row = nrow(self$player)
      player = data.frame(matrix(0, nrow = number_row/10, ncol = length(column_team1)*2+3)) 
      colnames(player) = c("id", "win", "duration", column_team1, column_team2)

      # We go over the dataset to create the new dataset
      i = 0
      j = 1
      while(i < number_row) {
        # We get the id of the 10 next rows
        id = self$player[(i+1):(i+10), "id"]

        # If all the id are the same: we have a good instance of a game
        if((all(!is.na(id))) && all(id[1] == id)) {
          # We get the id 
          id = id[1]
      
          print(id)

          # We get who win and we turn into something easier for the new representation
          # The new variable will be 1 if the first team wins and 0 otherwise
          if(self$player[(i+1), "win"] == 1) {
            win = 1
          } else {
            win = 0
          }

          # We get the duration of the game
          duration = self$player[(i+1), "duration"]
     
          # We create a vector for the team 1 and the team 2
          vector_team_1 = private$set_team_vector(self$player[(i+1):(i+5),])
          vector_team_2 = private$set_team_vector(self$player[(i+6):(i+10),])
  
          # We can create the whole vector
          row_vector = c(id, win, duration, vector_team_1, vector_team_2)
          player[j,] = row_vector 
          j = j + 1
          i = i + 10
        } else {
          # If we have a bad instance: we will go to the new id 
          k = 1
          while((!is.na(id[k])) && id[1] == id[k]) {
            k = k + 1
          }
          i = i + k - 1
          print(paste("Debug: the match", id[1], "is not exported"))
        }
      }
      # And we return the new dataset without the zero rows which was not modified
      # because of the bad instances
      player = player[-c(j:nrow(player)),]
      player
    },

    export_team = function() {
      # The function will be a dataset with the statistics of the teams

      # We take the columns of the dataset without the shared columns 
      column = colnames(self$team)
      column_without = c("matchid", "teamid")
      column = column[! column %in% column_without]

      # We create the name of the columns for the two teams
      column_team1 = lapply(column, function(x) { paste(x, "_1", sep="") })
      column_team2 = lapply(column, function(x) { paste(x, "_2", sep="") })
      column_team1 = unlist(column_team1)
      column_team2 = unlist(column_team2)

      # We create the dataset with zero rows
      number_row = nrow(self$team)
      team = data.frame(matrix(0, nrow = number_row/2, ncol = length(column_team1)*2+1)) 
      colnames(team) = c("id", column_team1, column_team2)

      # We go over the dataset to fill the new one
      i = 0 
      j = 1
      while(i < number_row) { 
   
        # We get the id of the two next rows to have a good instance of a match
        id = self$team[(i+1):(i+2),"matchid"]

        # We verify if we have a good instance
        if((all(!is.na(id))) && all(id[1] == id)) {
          # We get the id 
          id = id[1]

          print(id)
     
          # We get the two rows 
          row_team_1 = self$team[(i+1),]
          row_team_2 = self$team[(i+2),]

          # We remove the shared columns
          row_team_1["matchid"] = NULL
          row_team_2["matchid"] = NULL
          row_team_1["teamid"] = NULL
          row_team_2["teamid"] = NULL
      
          row_team_1 = unname(unlist(row_team_1))
          row_team_2 = unname(unlist(row_team_2))

          # We merge the two rows 
          team[j,] = c(id, row_team_1, row_team_2)
          j = j + 1
          i = i + 2
        } else {
          # We will go to the next id
          i = i + 1
          print(paste("Debug: the match", id[1], "is not exported"))
        }
      }
      # We return the new dataset
      team = team[-c(j:nrow(team)),]
      team
    },

    set_vector = function(row) {
      # The function will create a vector for a given row of the original dataset

      # We take the column of the dataset without the shared columns (shared by other rows)
      column = colnames(self$player)
      column_without = c("id", "win", "duration", "name", "role", "position")
      column = column[! column %in% column_without]
 
      # We create a vector of zeros which has the same length as the columns
      zero = rep(0, length(column))
      row_top = zero
      row_mid = zero 
      row_jungle = zero
      row_supp = zero
      row_carry = zero

      # We take the role and the position to modify the zero vector
      role = row["role"]
      position = row["position"]

      # We remove the shared columns
      row["id"] = NULL
      row["win"] = NULL
      row["duration"] = NULL
      row["name"] = NULL
      row["role"] = NULL
      row["position"] = NULL

      # And we modify the vector to fit with the role of the champion
      if(role == "DUO_SUPPORT") {
        row_supp = unname(unlist(row))
      }
      else if(role == "DUO_CARRY") {
        row_carry = unname(unlist(row))
      }
      else if(position == "TOP") {
        row_top = unname(unlist(row))
      }
      else if(position == "MID") {
        row_mid = unname(unlist(row))
      }
      else if(position == "JUNGLE") {
        row_jungle = unname(unlist(row))
      }

      # We have now a vector with zeros except where there is the champion
      # We fed the vector with the data of the original dataset
      c(row_top, row_mid, row_jungle, row_supp, row_carry)
    },

    set_team_vector = function(rows_team) {
      # We add the 5 vectors to have a vector with all the roles of the team
      vector_1 = private$set_vector(rows_team[1,])
      vector_2 = private$set_vector(rows_team[2,])
      vector_3 = private$set_vector(rows_team[3,])
      vector_4 = private$set_vector(rows_team[4,])
      vector_5 = private$set_vector(rows_team[5,])
      vector_1 + vector_2 + vector_3 + vector_4 + vector_5
    },

    export_split = function() {
      # We set the seed to sample the dataset in the same way
      set.seed(private$seed)

      # We get the number of rows
      number_row = nrow(self$stats)
      # We sample the dataset and we save it
      self$sample = private$export_sample(sort(sample(1:number_row, floor(0.6*number_row))), "dataset/sample_train.csv")
      # The first part will be the training set (60% of the original one)
      self$train = as.matrix(self$stats[self$sample, ])

      # It remains now 40%
      remain = self$stats[-self$sample,]

      # We sample in two parts the remaining dataset and we save it
      sample_remain = private$export_sample(sort(sample(1:nrow(remain), floor(0.5*nrow(remain)))), "dataset/sample_validation_test.csv")

      # The second part will be the validation set
      self$validation = remain[sample_remain, ]
      # and the last part will be the test set
      self$test = remain[-sample_remain,]

      # We get the labels of the datasets
      self$train_label = self$stats_label[self$sample]
      remain_label = self$stats_label[-self$sample]
      self$validation_label = remain_label[sample_remain]
      self$test_label = remain_label[-sample_remain]
    },

    export_sample = function(fun, file) {
      # If the dataset sample exists
      if(file.exists(file)) {
        # We read the file and we export it
        sample = private$read(file)
        sample = sample[1:nrow(sample),]
      } else {
        # otherwise, we execute the function
        sample = fun
        private$write(sample, file)
      }
      sample
    },

    read = function(path) {
      # We read a dataset if the file exists
      file = NA
      if(file.exists(path)) {
        file = read.csv(path, row.names = 1)
      }
      file
    },

    write = function(data, file) {
      # We write the dataset in a file
      write.csv(data, file)
    }
 
  )
)
