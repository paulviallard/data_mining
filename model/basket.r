#!/usr/bin/env Rscript

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


dataset_transaction.compute = function() {

  dataset_ban_basket.transactions = dataset_ban_basket.compute_transactions()
  print(head(dataset_ban_basket.transactions))

  dataset_ban_basket.transactions$id = factor(dataset_ban_basket.transactions$id)
  dataset_ban_basket.transactions = split(dataset_ban_basket.transactions[, "name"], f=dataset_ban_basket.transactions$id)
  dataset_ban_basket.transactions = as(dataset_ban_basket.transactions, "transactions")
  dataset_ban_basket.transactions
}

dataset_transaction.compute_rule = function() {
  dataset_transaction.rule = apriori(dataset_transaction.data, parameter=list(support=0.005, confidence=0.501), appearance = list(rhs = c("Win", "Loose")))
  dataset_transaction.rule
}

dataset_transaction.print_rule = function() {
  print(inspect(sort(subset(dataset_transaction.rule, subset=confidence > 0.53), by="confidence")))
}

dataset_basket.file = "dataset/Understanding/proba_transactions.csv"
dataset_ban_basket.file = "dataset/Understanding/proba_ban_transactions.csv"
dataset_transaction.data = dataset_transaction.compute()

inspect(dataset_transaction.data)

dataset_transaction.rule = dataset_transaction.compute_rule()
dataset_transaction.print_rule()
