#!/usr/bin/env Rscript

library(Matrix)
library(arules)

# The class DatasetTransaction represents the matrix of transactions
DatasetTransaction = R6Class("DatasetTransaction",
  inherit = Dataset,
  public = list(
    transaction = NULL,

    initialize = function(dataset = NULL, dbname = "lol", username = "root", password = "") {
      # We will load the matrix of transactions
      # If we have no dataset
      if(is.null(dataset)) {
        # We will export the dataset from MySQL
        super$initialize(dbname, username, password)
      } else {
        # If we have already a dataset we can set the different 
        # exported dataset
        self$champs = dataset$champs
        self$bans = dataset$bans
        self$player = dataset$player
        self$team = dataset$team
      }
      # If the file with the matrix doesn't exist
      if(!file.exists("dataset/export_transaction.rds")) {
        # We exported the matrix
        self$transaction = private$export()
        # and we save it
        saveRDS(self$transaction, file="dataset/export_transaction.rds")
      } else {
        # Otherwise, we load from the file
        self$transaction = readRDS("dataset/export_transaction.rds")
      }
    },
    
    print = function() {
      # We print the matrix of transactions
      inspect(head(self$transaction))
    }
  ),

  private = list(

    export = function() {
      # We export the matrix from the dataset champions
      # We compute a intermediate representation
      transaction = private$compute_()

      # We factorize by the transaction ID 
      transaction$id = factor(transaction$id)
      transaction = split(transaction[, "name"], f=transaction$id)
      
      # We compute the matrix of transactions
      transaction = as(transaction, "transactions")
      transaction
    },

    compute_ = function() {
      # If we don't have the intermediate representation
      if(!file.exists("dataset/export_transaction.csv")) {
        # We will compute it

        # We get the id of the games
        dataset_id = unique(self$champs[,"id"])

        # We create a new dataset to store the item "Win" and "Loose"
        transaction_win_loose = data.frame(matrix(0, nrow = 2*length(dataset_id), ncol = 2))
        colnames(transaction_win_loose) = c("id", "name")

        j = 0
        for(id in dataset_id) {
          # We create the id of the winner (id:1) and the looser (id:0)
          id_loose = paste(as.character(id),":","0", sep="")
          id_win = paste(as.character(id),":","1", sep="")

          # We fill the dataset in 
          j = j+1 
          transaction_win_loose[j,] = c(id_loose, "Loose")
          j = j+1
          transaction_win_loose[j,] = c(id_win, "Win")
        }

        # We replace the column win by the new id
        transaction$id = paste(as.character(transaction$id),":",as.character(transaction$win), sep="")
        # and we remove the column win
        transaction[,"win"] = NULL

        # We merge the two datasets
        transaction = rbind(transaction, transaction_win_loose)
        # and we write our intermediate representation
        private$write(transaction, "dataset/export_transaction.csv")
      } else {
        # If we have the file we can export it 
        transaction = private$read("dataset/export_transaction.csv")
      }
      transaction
    },

    read = function(path) {
      # We read a dataset
      file = NA
      if(file.exists(path)) {
        file = read.csv(path, row.names = 1)
      }
      file
    },

    write = function(data, file) {
      # We write a dataset
      write.csv(data, file)
    }
  )
)
