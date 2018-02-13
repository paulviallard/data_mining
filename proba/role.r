#!/usr/bin/env Rscript

dataset.debug = function(data) {
  print("Debug: we exported the role dataset")
  print(data)
}

dataset_role.compute_main = function() {
  if(!file.exists(dataset_role.file)) {
    dataset_role.rows = unique(dataset_role.data$name)
    dataset_role.count = data.frame(matrix(0, nrow = length(dataset_role.rows), ncol = 5))
    colnames(dataset_role.count) = c("Top", "Mid", "Jungle", "Support", "Carry")
    row.names(dataset_role.count) = dataset_role.rows
    
    dataset_role.nrow = nrow(dataset_role.data)
    
    for (i in 1:dataset_role.nrow) {
      print(i)
      if (dataset_role.data[i, "position"] == "JUNGLE") {
        name = dataset_role.data[i, "name"]
        dataset_role.count[name, "Jungle"] = dataset_role.count[name, "Jungle"]+1
      } else if(dataset_role.data[i, "position"] == "TOP") {
        name = dataset_role.data[i, "name"]
        dataset_role.count[name, "Top"] = dataset_role.count[name, "Top"]+1
      } else if(dataset_role.data[i, "position"] == "MID") {
        name = dataset_role.data[i, "name"]
        dataset_role.count[name, "Mid"] = dataset_role.count[name, "Mid"]+1
      } else if(dataset_role.data[i, "role"] == "DUO_SUPPORT") {
        name = dataset_role.data[i, "name"]
        dataset_role.count[name, "Support"] = dataset_role.count[name, "Support"]+1
      } else if(dataset_role.data[i, "role"] == "DUO_CARRY") {
        name = dataset_role.data[i, "name"]
        dataset_role.count[name, "Carry"] = dataset_role.count[name, "Carry"]+1
      }
    }

    dataset_role.main = data.frame(matrix(0, nrow = length(dataset_role.rows), ncol = 1))
    colnames(dataset_role.main) = c("Main")
    row.names(dataset_role.main) = dataset_role.rows

    for(i in 1:length(dataset_role.rows)) {
      argmax = "Jungle"
      max = dataset_role.count[i, "Jungle"]

      if(dataset_role.count[i, "Top"] > max) {
        argmax = "Top"
        max = dataset_role.count[i, "Top"]
      }

      if(dataset_role.count[i, "Mid"] > max) {
        argmax = "Mid"
        max = dataset_role.count[i, "Mid"]
      }

      if(dataset_role.count[i, "Support"] > max) {
        argmax = "Support"
        max = dataset_role.count[i, "Support"]
      }

      if(dataset_role.count[i, "Carry"] > max) {
        argmax = "Carry"
        max = dataset_role.count[i, "Carry"]
      }
      
      dataset_role.main[i, "Main"] = argmax
    }

    write.csv(dataset_role.main, dataset_role.file)
  } else {
    dataset_role.main = read.csv(dataset_role.file, row.names = 1)
  }
  dataset_role.main
}

dataset_role.file = "Data/Understanding/proba_main.csv"
dataset_role.main = dataset_role.compute_main()
dataset.debug(dataset_role.main)
