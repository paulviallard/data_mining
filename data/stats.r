#!/usr/bin/env Rscript

dataset_player_stats.set_vector = function(row) {
  # The function will create a vector for a given row of the original dataset

  # We take the column of the dataset without the shared columns (shared by other rows)
  dataset_player_stats.col = colnames(dataset_player_stats.data)
  dataset_player_stats.col_without = c("id", "win", "duration", "name", "role", "position")
  dataset_player_stats.col = dataset_player_stats.col[! dataset_player_stats.col %in% dataset_player_stats.col_without]
 
  # We create a vector of zeros which has the same length of the columns
  zero = rep(0, length(dataset_player_stats.col))
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

  # We have now a vector with zeros except where there are the role of the champion
  # We fed the vector with the data of the original dataset
  c(row_top, row_mid, row_jungle, row_supp, row_carry)
}

dataset_player_stats.set_team_vector = function(rows_team) {
  # We add the 5 vectors to have a vector with all the roles of the team
  vector_1 = dataset_player_stats.set_vector(rows_team[1,])
  vector_2 = dataset_player_stats.set_vector(rows_team[2,])
  vector_3 = dataset_player_stats.set_vector(rows_team[3,])
  vector_4 = dataset_player_stats.set_vector(rows_team[4,])
  vector_5 = dataset_player_stats.set_vector(rows_team[5,])
  vector_1 + vector_2 + vector_3 + vector_4 + vector_5
}


dataset_stats.compute_player = function() {
  # The function will create a dataset with all the columns corresponding to all roles of a team and with the two teams

  # We remove some shared columns
  dataset_player_stats.col = colnames(dataset_player_stats.data)
  dataset_player_stats.col_without = c("id", "win", "duration", "name", "role", "position")
  dataset_player_stats.col = dataset_player_stats.col[! dataset_player_stats.col %in% dataset_player_stats.col_without]

  # We create the columns for the top
  dataset_player_stats.col_top = lapply(dataset_player_stats.col, function(x) { paste(x, "_top", sep="") })
  dataset_player_stats.col_top = unlist(dataset_player_stats.col_top)

  # We create the columns for the mid
  dataset_player_stats.col_mid = lapply(dataset_player_stats.col, function(x) { paste(x, "_mid", sep="") })
  dataset_player_stats.col_mid = unlist(dataset_player_stats.col_mid)

  # We create the columns for the jungle
  dataset_player_stats.col_jungle = lapply(dataset_player_stats.col, function(x) { paste(x, "_jungle", sep="") })
  dataset_player_stats.col_jungle = unlist(dataset_player_stats.col_jungle)

  # We create the columns for the support
  dataset_player_stats.col_supp = lapply(dataset_player_stats.col, function(x) { paste(x, "_supp", sep="") })
  dataset_player_stats.col_supp = unlist(dataset_player_stats.col_supp)

  # We create the columns for the AD Carry
  dataset_player_stats.col_carry = lapply(dataset_player_stats.col, function(x) { paste(x, "_carry", sep="") })
  dataset_player_stats.col_carry = unlist(dataset_player_stats.col_carry)

  # We create the columns with all the roles for the two teams
  dataset_stats.col_team1 = c(dataset_player_stats.col_top, dataset_player_stats.col_mid, dataset_player_stats.col_jungle, dataset_player_stats.col_supp, dataset_player_stats.col_carry)
  dataset_stats.col_team2 = dataset_stats.col_team1

  # We rename the columns for the first and the second team
  dataset_stats.col_team1 = lapply(dataset_stats.col_team1, function(x) { paste(x, "_1", sep="") })
  dataset_stats.col_team2 = lapply(dataset_stats.col_team2, function(x) { paste(x, "_2", sep="") })
  dataset_stats.col_team1 = unlist(dataset_stats.col_team1)
  dataset_stats.col_team2 = unlist(dataset_stats.col_team2)

  # We create a new dataframe which will be our dataset
  dataset_player_stats.nrow = nrow(dataset_player_stats.data)
  dataset_stats.data = data.frame(matrix(0, nrow = dataset_player_stats.nrow/10, ncol = length(dataset_stats.col_team1)*2+3)) 
  colnames(dataset_stats.data) = c("id", "win", "duration", dataset_stats.col_team1, dataset_stats.col_team2)

  # We go over the dataset to create the new dataset
  i = 0
  j = 1
  while(i < dataset_player_stats.nrow) {
    # We get the id of the 10 next rows
    id = dataset_player_stats.data[(i+1):(i+10), "id"]

    # If all the id are the same: we have a good instance of a game
    if((all(!is.na(id))) && all(id[1] == id)) {
      # We get the id 
      id = id[1]
      
      print(id)

      # We get who win and we turn into somethings easier for the new representation
      # The new variable will be 1 if the first team win and 0 otherwise
      if(dataset_player_stats.data[(i+1), "win"] == 1) {
        win = 1
      } else {
        win = 0
      }

      # We get the duration of the game
      duration = dataset_player_stats.data[(i+1), "duration"]
     
      # We create a vector for the team 1 and the team 2
      vector_team_1 = dataset_player_stats.set_team_vector(dataset_player_stats.data[(i+1):(i+5),])
      vector_team_2 = dataset_player_stats.set_team_vector(dataset_player_stats.data[(i+6):(i+10),])
  
      # We get create the whole vector
      row_vector = c(id, win, duration, vector_team_1, vector_team_2)
      dataset_stats.data[j,] = row_vector 
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
  dataset_stats.data = dataset_stats.data[-c(j:nrow(dataset_stats.data)),]
  dataset_stats.data
}

dataset_stats.compute_team = function() {
  # The function will a dataset with the statistics of the teams

  # We take the columns of the dataset without the shared columns 
  dataset_team_stats.col = colnames(dataset_team_stats.data)
  dataset_team_stats.col_without = c("matchid", "teamid")
  dataset_team_stats.col = dataset_team_stats.col[! dataset_team_stats.col %in% dataset_team_stats.col_without]

  # We create the name of the columns for the two teams
  dataset_stats.col_team1 = lapply(dataset_team_stats.col, function(x) { paste(x, "_1", sep="") })
  dataset_stats.col_team2 = lapply(dataset_team_stats.col, function(x) { paste(x, "_2", sep="") })
  dataset_stats.col_team1 = unlist(dataset_stats.col_team1)
  dataset_stats.col_team2 = unlist(dataset_stats.col_team2)

  # We create the dataset with zero rows
  dataset_team_stats.nrow = nrow(dataset_team_stats.data)
  dataset_stats.data = data.frame(matrix(0, nrow = dataset_team_stats.nrow/2, ncol = length(dataset_stats.col_team1)*2+1)) 
  colnames(dataset_stats.data) = c("id", dataset_stats.col_team1, dataset_stats.col_team2)

  # We go over the dataset to fill the new one
  i = 0 
  j = 1
  while(i < dataset_team_stats.nrow) { 
   
    # We get the id of the two next rows to have a good instance of a match
    id = dataset_team_stats.data[(i+1):(i+2),"matchid"]

    # We verify if we have a good instance
    if((all(!is.na(id))) && all(id[1] == id)) {
      # We get the id 
      id = id[1]

      print(id)
     
      # We get the two rows 
      row_team_1 = dataset_team_stats.data[(i+1),]
      row_team_2 = dataset_team_stats.data[(i+2),]

      # We remove the shared columns
      row_team_1["matchid"] = NULL
      row_team_2["matchid"] = NULL
      row_team_1["teamid"] = NULL
      row_team_2["teamid"] = NULL
      
      row_team_1 = unname(unlist(row_team_1))
      row_team_2 = unname(unlist(row_team_2))

      # We merge the two rows 
      dataset_stats.data[j,] = c(id, row_team_1, row_team_2)
      j = j + 1
      i = i + 2
    } else {
      # We will go to the next id
      i = i + 1
      print(paste("Debug: the match", id[1], "is not exported"))
    }
  }
  # We return the new dataset
  dataset_stats.data = dataset_stats.data[-c(j:nrow(dataset_stats.data)),]
  dataset_stats.data
}

dataset_stats.compute = function() {
  # We will compute the dataset

  # If the dataset doesn't exist we will create it
  if(!file.exists(dataset_stats.file)) {
    # We compute the two datasets
    dataset_stats.player = dataset_stats.compute_player()
    dataset_stats.team = dataset_stats.compute_team()
    
    # We merge it
    dataset_stats.data = merge(dataset_stats.player,dataset_stats.team, by="id")
    
    # The name of the rows will be the id
    row.names(dataset_stats.data) = dataset_stats.data[,"id"]
    dataset_stats.data[,"id"] = NULL

    # We remove the NA data
    dataset_stats.data = na.omit(dataset_stats.data)

    # And we export it
    write.csv(dataset_stats.data, dataset_stats.file)
  } else {
    # We have the file we can import it
    dataset_stats.data = read.csv(dataset_stats.file, row.names = 1)
  }
  # We return the new dataset
  dataset_stats.data
}

# We import the dataset
dataset_stats.file = "dataset/Understanding/proba_stats.csv"
dataset_stats.data = dataset_stats.compute()

# We take the labels
dataset_stats.label = dataset_stats.data[,"win"]
dataset_stats.data[,"win"] = NULL
