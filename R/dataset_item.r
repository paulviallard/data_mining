#!/usr/bin/env Rscript

library(jsonlite)

# The class DatasetItem represents the json file for the items
DatasetItem = R6Class("DatasetItem",
  inherit = Dataset,
  public = list(
    initialize = function() {
      # If the file doesn't exist, we will create it 
      if((!file.exists("dataset/item.csv")) || (!file.exists("dataset/summoner.csv"))) {
        # We load the JSON file 
        json_item = fromJSON("http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/item.json")
        json_summoner = fromJSON("http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/summoner.json")
        id_item = names(json_item$data)
        name_item = rep(1:length(id_item), 0)

        json_item = unname(json_item$data)
        for (i in 1:length(json_item)) {
          name_item[i] = json_item[[i]]$name
        }
        dataset_item = cbind(id_item, name_item)
        colnames(dataset_item) = c("id", "name")
      
        write.csv(dataset_item, file="dataset/item.csv", row.names = FALSE)

        id_summoner = rep(1:length(json_summoner), 0)
        name_summoner = rep(1:length(json_summoner), 0)

        json_summoner = unname(json_summoner$data)
        for (i in 1:length(json_summoner)) {
          id_summoner[i] = json_summoner[[i]]$key
          name_summoner[i] = json_summoner[[i]]$name
        }
        dataset_summoner = cbind(id_summoner, name_summoner)
        colnames(dataset_summoner) = c("id", "name")

        write.csv(dataset_summoner, file="dataset/summoner.csv", row.names = FALSE)
      }
    }
  )
)
