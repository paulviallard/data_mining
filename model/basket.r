#!/usr/bin/env Rscript

dataset_ban_basket.compute_transactions = function() {
  if(!file.exists(dataset_ban_basket.file)) {
    dataset_ban_basket.nrow = nrow(dataset_ban_basket.data)
    dataset_ban_basket.transactions = data.frame(matrix(0, nrow = 2*dataset_ban_basket.nrow, ncol = 2))
    colnames(dataset_ban_basket.transactions) = c("id", "name")

    j = 0
    for (i in 1:dataset_ban_basket.nrow) {
      print(i)
      id = dataset_ban_basket.data[i,"id"]
      id_loose = paste(as.character(id),":","0", sep="")
      id_win = paste(as.character(id),":","1", sep="")
      name_ban = paste(as.character(dataset_ban_basket.data[i,"name"]), "Ban")      
      j = j+1
      dataset_ban_basket.transactions[j,] = c(id_loose, name_ban)
      j = j+1
      dataset_ban_basket.transactions[j,] = c(id_win, name_ban)
    }
    dataset_ban_basket.data = dataset_ban_basket.transactions
    write.csv(dataset_ban_basket.data, dataset_ban_basket.file)
  } else {
    dataset_ban_basket.data = read.csv(dataset_ban_basket.file, row.names = 1)
  }
  dataset_ban_basket.data
}

dataset_basket.compute_transactions = function() {
  if(!file.exists(dataset_basket.file)) {
    dataset_basket.id = unique(dataset_basket.data[,"id"])

    dataset_basket.transactions = data.frame(matrix(0, nrow = 2*length(dataset_basket.id), ncol = 2))
    colnames(dataset_basket.transactions) = c("id", "name")

    j = 0
    for(id in dataset_basket.id) {
      print(id)
      id_loose = paste(as.character(id),":","0", sep="")
      id_win = paste(as.character(id),":","1", sep="")

      j = j+1 
      dataset_basket.transactions[j,] = c(id_loose, "Loose")
      j = j+1
      dataset_basket.transactions[j,] = c(id_win, "Win")
    }

    dataset_basket.data$id = paste(as.character(dataset_basket.data$id),":",as.character(dataset_basket.data$win), sep="")
    dataset_basket.data[,"win"] = NULL

    dataset_basket.data = rbind(dataset_basket.data, dataset_basket.transactions)
    write.csv(dataset_basket.data, dataset_basket.file)
  } else {
    dataset_basket.data = read.csv(dataset_basket.file, row.names = 1)
  }
  dataset_basket.data
}

dataset_basket.compute_matrix = function() {
  dataset_basket.file = "Data/Understanding/proba_transactions.csv"
  dataset_basket.transactions = dataset_basket.compute_transactions()

}

dataset_transaction.compute = function() {

  dataset_ban_basket.file = "Data/Understanding/proba_ban_transactions.csv"
  dataset_ban_basket.transactions = dataset_ban_basket.compute_transactions()
  print(head(dataset_ban_basket.transactions))

  dataset_transaction.data$id = factor(dataset_transaction.data$id)
  dataset_transaction.data = split(dataset_transaction.data[, "name"], f=dataset_transaction.data$id)
  dataset_transaction.data = as(dataset_transaction.data, "transactions")
  dataset_transaction.data
}

dataset_transaction.compute_rule = function() {
  dataset_transaction.rule = apriori(dataset_transaction.data, parameter=list(support=0.005, confidence=0.501), appearance = list(rhs = c("Win", "Loose")))
  dataset_transaction.rule
}

dataset_transaction.print_rule = function() {
  print(inspect(sort(subset(dataset_transaction.rule, subset=confidence > 0.53), by="confidence")))
}


dataset_transaction.data = dataset_transaction.compute()
inspect(dataset_transaction.data)
dataset_transaction.rule = dataset_transaction.compute_rule()

# write(dataset_transaction.rule,
      # file = "Data/Understanding/proba_rules.csv",
      # sep = ",",
      # quote = TRUE,
      # row.names = FALSE)

dataset_transaction.print_rule()
