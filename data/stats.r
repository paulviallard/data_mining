#!/usr/bin/env Rscript

dataset_player_stats.set_vector = function(row) {
  dataset_player_stats.col = colnames(dataset_player_stats.data)
  dataset_player_stats.col_without = c("id", "win", "duration", "name", "role", "position")
  dataset_player_stats.col = dataset_player_stats.col[! dataset_player_stats.col %in% dataset_player_stats.col_without]
  zero = rep(0, length(dataset_player_stats.col))
  row_top = zero
  row_mid = zero 
  row_jungle = zero
  row_supp = zero
  row_carry = zero

  role = row["role"]
  position = row["position"]

  row["id"] = NULL
  row["win"] = NULL
  row["duration"] = NULL
  row["name"] = NULL
  row["role"] = NULL
  row["position"] = NULL

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
  c(row_top, row_mid, row_jungle, row_supp, row_carry)
}

dataset_player_stats.set_team_vector = function(rows_team) {
  vector_1 = dataset_player_stats.set_vector(rows_team[1,])
  vector_2 = dataset_player_stats.set_vector(rows_team[2,])
  vector_3 = dataset_player_stats.set_vector(rows_team[3,])
  vector_4 = dataset_player_stats.set_vector(rows_team[4,])
  vector_5 = dataset_player_stats.set_vector(rows_team[5,])
  vector_1 + vector_2 + vector_3 + vector_4 + vector_5
}


dataset_stats.compute_player = function() {
  dataset_player_stats.col = colnames(dataset_player_stats.data)
  dataset_player_stats.col_without = c("id", "win", "duration", "name", "role", "position")
  dataset_player_stats.col = dataset_player_stats.col[! dataset_player_stats.col %in% dataset_player_stats.col_without]

  dataset_player_stats.col_top = lapply(dataset_player_stats.col, function(x) { paste(x, "_top", sep="") })
  dataset_player_stats.col_top = unlist(dataset_player_stats.col_top)

  dataset_player_stats.col_mid = lapply(dataset_player_stats.col, function(x) { paste(x, "_mid", sep="") })
  dataset_player_stats.col_mid = unlist(dataset_player_stats.col_mid)

  dataset_player_stats.col_jungle = lapply(dataset_player_stats.col, function(x) { paste(x, "_jungle", sep="") })
  dataset_player_stats.col_jungle = unlist(dataset_player_stats.col_jungle)

  dataset_player_stats.col_supp = lapply(dataset_player_stats.col, function(x) { paste(x, "_supp", sep="") })
  dataset_player_stats.col_supp = unlist(dataset_player_stats.col_supp)

  dataset_player_stats.col_carry = lapply(dataset_player_stats.col, function(x) { paste(x, "_carry", sep="") })
  dataset_player_stats.col_carry = unlist(dataset_player_stats.col_carry)

  dataset_stats.col_team1 = c(dataset_player_stats.col_top, dataset_player_stats.col_mid, dataset_player_stats.col_jungle, dataset_player_stats.col_supp, dataset_player_stats.col_carry)
  dataset_stats.col_team2 = dataset_stats.col_team1

  dataset_stats.col_team1 = lapply(dataset_stats.col_team1, function(x) { paste(x, "_1", sep="") })
  dataset_stats.col_team2 = lapply(dataset_stats.col_team2, function(x) { paste(x, "_2", sep="") })
  dataset_stats.col_team1 = unlist(dataset_stats.col_team1)
  dataset_stats.col_team2 = unlist(dataset_stats.col_team2)

  dataset_player_stats.nrow = nrow(dataset_player_stats.data)
  
  dataset_stats.data = data.frame(matrix(0, nrow = dataset_player_stats.nrow/10, ncol = length(dataset_stats.col_team1)*2+3)) 
  colnames(dataset_stats.data) = c("id", "win", "duration", dataset_stats.col_team1, dataset_stats.col_team2)

  i = 0
  j = 1
  while(i < dataset_player_stats.nrow) { 
    id = dataset_player_stats.data[(i+1):(i+10), "id"]

    if((all(!is.na(id))) && all(id[1] == id)) {
      id = id[1]
      
      print(id)

      if(dataset_player_stats.data[(i+1), "win"] == 1) {
        win = 1
      } else {
        win = 0
      }

      duration = dataset_player_stats.data[(i+1), "duration"]
      
      vector_team_1 = dataset_player_stats.set_team_vector(dataset_player_stats.data[(i+1):(i+5),])
      vector_team_2 = dataset_player_stats.set_team_vector(dataset_player_stats.data[(i+6):(i+10),])
   
      row_vector = c(id, win, duration, vector_team_1, vector_team_2)
      dataset_stats.data[j,] = row_vector 
      j = j + 1
      i = i + 10
    } else {
      k = 1
      while((!is.na(id[k])) && id[1] == id[k]) {
        k = k + 1
      }
      i = i + k - 1
      print(paste("Debug: the match", id[1], "is not exported"))
    }
  }
  dataset_stats.data = dataset_stats.data[-c(j:nrow(dataset_stats.data)),]
  dataset_stats.data
}

dataset_stats.compute_team = function() {
  dataset_team_stats.col = colnames(dataset_team_stats.data)
  dataset_team_stats.col_without = c("matchid", "teamid")
  dataset_team_stats.col = dataset_team_stats.col[! dataset_team_stats.col %in% dataset_team_stats.col_without]

  dataset_stats.col_team1 = lapply(dataset_team_stats.col, function(x) { paste(x, "_1", sep="") })
  dataset_stats.col_team2 = lapply(dataset_team_stats.col, function(x) { paste(x, "_2", sep="") })
  dataset_stats.col_team1 = unlist(dataset_stats.col_team1)
  dataset_stats.col_team2 = unlist(dataset_stats.col_team2)

  dataset_team_stats.nrow = nrow(dataset_team_stats.data)
  print(length(dataset_stats.col_team1)*2+1) 
  dataset_stats.data = data.frame(matrix(0, nrow = dataset_team_stats.nrow/2, ncol = length(dataset_stats.col_team1)*2+1)) 
  colnames(dataset_stats.data) = c("id", dataset_stats.col_team1, dataset_stats.col_team2)

  i = 0 
  j = 1
  while(i < dataset_team_stats.nrow) { 
    
    id = dataset_team_stats.data[(i+1):(i+2),"matchid"]

    if((all(!is.na(id))) && all(id[1] == id)) {
      id = id[1]

      print(id)
      
      row_team_1 = dataset_team_stats.data[(i+1),]
      row_team_2 = dataset_team_stats.data[(i+2),]

      row_team_1["matchid"] = NULL
      row_team_2["matchid"] = NULL
      row_team_1["teamid"] = NULL
      row_team_2["teamid"] = NULL
      
      row_team_1 = unname(unlist(row_team_1))
      row_team_2 = unname(unlist(row_team_2))

      dataset_stats.data[j,] = c(id, row_team_1, row_team_2)
      j = j + 1
      i = i + 2
    } else {
      i = i + 1
      print(paste("Debug: the match", id[1], "is not exported"))
    }
  }
  dataset_stats.data = dataset_stats.data[-c(j:nrow(dataset_stats.data)),]
  dataset_stats.data
}

dataset_stats.compute = function() {
  if(!file.exists(dataset_stats.file)) {
    dataset_stats.player = dataset_stats.compute_player()
    dataset_stats.team = dataset_stats.compute_team()
    dataset_stats.data = merge(dataset_stats.player,dataset_stats.team, by="id")
    row.names(dataset_stats.data) = dataset_stats.data[,"id"]
    dataset_stats.data[,"id"] = NULL
    dataset_stats.data = na.omit(dataset_stats.data)
    write.csv(dataset_stats.data, dataset_stats.file)
  } else {
    dataset_stats.data = read.csv(dataset_stats.file, row.names = 1)
  }
  dataset_stats.data
}

dataset_stats.file = "Data/Understanding/proba_stats.csv"
dataset_stats.data = dataset_stats.compute()
dataset_stats.label = dataset_stats.data[,"win"]
dataset_stats.data[,"win"] = NULL
dataset_stats.pca = princomp(dataset_stats.data, scores = TRUE)
dataset_stats.scores = as.data.frame(dataset_stats.pca$scores)
dataset_stats.pca$loadings

dataset_stats.comp1 = dataset_stats.pca$loadings[,1]*dataset_stats.pca$sdev[1] 
dataset_stats.comp2 = dataset_stats.pca$loadings[,2]*dataset_stats.pca$sdev[2]
dataset_stats.comp3 = dataset_stats.pca$loadings[,3]*dataset_stats.pca$sdev[3]
dataset_stats.comp_zero = rep(0, length(dataset_stats.comp1))
dataset_stats.comp = data.frame(dataset_stats.comp1,dataset_stats.comp2,dataset_stats.comp3, dataset_stats.comp_zero)
colnames(dataset_stats.comp) = c("comp1", "comp2", "comp3", "zero")


ggplot(dataset_stats.scores, aes(Comp.1, Comp.2, color = dataset_stats.label)) + geom_point()

ggplot(dataset_stats.comp, aes(zero, zero, label = as.character(row.names(dataset_stats.comp)))) + geom_segment(aes(xend=comp1, yend=comp2), size=2, arrow = arrow(length = unit(0.2,"cm"))) + geom_text(aes(comp1, comp2))

ggplot() + geom_point(dataset_stats.scores, aes(Comp.1, Comp.2))

dataset_stats.label2 = lapply(dataset_stats.label, function(x) { x+1 })
dataset_stats.label2 = unlist(dataset_stats.label2)

plot3d(dataset_stats.scores$Comp.1, dataset_stats.scores$Comp.2, dataset_stats.scores$Comp.3, xlab="Component 1", ylab="Component 2", 
zlab="Component 3", col=dataset_stats.label2)
