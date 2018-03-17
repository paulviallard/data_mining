#!/usr/bin/env Rscript

library(Matrix)
library(arules)

# The class DatasetTransaction represents the matrix of transactions
DatasetTransactionItem = R6Class("DatasetTransactionItem",
  inherit = Dataset,
  public = list(
    transaction_item = NULL,

    initialize = function(dataset = NULL, dbname = "lol", username = "root", password = "") {
      # We will load the matrix of transactions
      # If we have no dataset
      if(is.null(dataset)) {
        # We will export the dataset from MySQL
        super$initialize(dbname, username, password)
      } else {
        # If we already have a dataset we can set the different 
        # exported dataset
        self$item = dataset$item
      }
      # If the file with the matrix doesn't exist
      if(!file.exists("dataset/export_item.rds")) {
        # We exported the matrix
        self$transaction_item = private$export()
        # and we save it
        saveRDS(self$transaction_item, file="dataset/export_item.rds")
      } else {
        # Otherwise, we load from the file
        self$transaction_item = readRDS("dataset/export_item.rds")
      }
    },
    
    print = function() {
      # We print the matrix of transactions
      inspect(head(self$transaction_item))
    }
  ),

  private = list(

    export = function() {

      # We load the dataset from DDragon
      item = private$read("dataset/item.csv")
      rownames(item) = item$id
      summoner = private$read("dataset/summoner.csv")
      rownames(summoner) = summoner$id
       
      # We convert the columns into character
      item[, "name"] = as.character(item[,"name"])
      summoner[, "name"] = as.character(summoner[,"name"])
      self$item[,"item1"] = as.character(self$item[,"item1"])
      self$item[,"item2"] = as.character(self$item[,"item2"])
      self$item[,"item3"] = as.character(self$item[,"item3"])
      self$item[,"item4"] = as.character(self$item[,"item4"])
      self$item[,"item5"] = as.character(self$item[,"item5"])
      self$item[,"item6"] = as.character(self$item[,"item6"])
      self$item[,"trinket"] = as.character(self$item[,"trinket"])
      self$item[,"ss1"] = as.character(self$item[,"ss1"])
      self$item[,"ss2"] = as.character(self$item[,"ss2"])
      self$item[,"role"] = as.character(self$item[,"role"])
      self$item[,"role"] = as.character(self$item[,"win"])
      
      print(nrow(self$item))
      # For each row,
      for (i in 1:nrow(self$item)) {
        print(i)
        # We get the id of the items
        item1 = self$item[i,"item1"]
        item2 = self$item[i,"item2"]
        item3 = self$item[i,"item3"]
        item4 = self$item[i,"item4"]
        item5 = self$item[i,"item5"]
        item6 = self$item[i,"item6"]
        trinket = self$item[i,"trinket"]
        ss1 = self$item[i,"ss1"]
        ss2 = self$item[i,"ss2"]

        # We get the name corresponding to the id and we change the dataset
        self$item[i,"item1"] = item[item1, "name"]
        self$item[i,"item2"] = item[item2, "name"]
        self$item[i,"item3"] = item[item3, "name"]
        self$item[i,"item4"] = item[item4, "name"]
        self$item[i,"item5"] = item[item5, "name"]
        self$item[i,"item6"] = item[item6, "name"]
        self$item[i,"trinket"] = item[trinket, "name"]
        self$item[i,"ss1"] = summoner[ss1, "name"]
        self$item[i,"ss2"] = summoner[ss2, "name"]

        # We create names for the outcome
        if(self$item[i,"win"] == 0) {
          self$item[i,"win"] = "Lose"
        } else {
          self$item[i,"win"] = "Win"
        }

        # We change the name for the role
        if(self$item[i,"position"] == "MID") {
          self$item[i,"role"] = "mid"
        }
        else if(self$item[i,"position"] == "TOP") {
          self$item[i,"role"] = "top"
        }
        else if(self$item[i,"position"] == "JUNGLE") {
          self$item[i,"role"] = "jungle"
        }
        else if(self$item[i,"role"] == "DUO_SUPPORT") {
          self$item[i,"role"] = "support"
        }
        else {
          self$item[i,"role"] = "carry"
        } 
      }
      # We convert the columns as factor
      self$item[,"win"] = as.factor(self$item[,"win"])
      self$item[,"item1"] = as.factor(self$item[,"item1"])
      self$item[,"item2"] = as.factor(self$item[,"item2"])
      self$item[,"item3"] = as.factor(self$item[,"item3"])
      self$item[,"item4"] = as.factor(self$item[,"item4"])
      self$item[,"item5"] = as.factor(self$item[,"item5"])
      self$item[,"item6"] = as.factor(self$item[,"item6"])
      self$item[,"trinket"] = as.factor(self$item[,"trinket"])
      self$item[,"ss1"] = as.factor(self$item[,"ss1"])
      self$item[,"ss2"] = as.factor(self$item[,"ss2"])
      self$item[,"role"] = as.factor(self$item[,"role"])

      # We remove the rows where there are NA values
      self$item[,"position"] = NULL 
      self$item = na.omit(self$item)
      as(self$item, "transactions")
    },
 
    read = function(path) {
      # We read a dataset
      file = NA
      if(file.exists(path)) {
        file = read.csv(path)
      }
      file
    }
  )
)
