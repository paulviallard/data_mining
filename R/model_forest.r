#!/usr/bin/env Rscript

library(randomForest)
library(caret)
source("model.r")

# The class ModelForest represents the model random forest
ModelForest = R6Class("ModelForest",
  inherit = Model,
  public = list(
    initialize = function(ntree = 10, file=NULL, dataset = NULL, dbname = "lol", username = "root", password = "") {
      # We will create the model
      model = NULL
      # If the dataset is null,
      if(is.null(dataset)) {
        # we will create the dataset
        dataset = DatasetStats(dataset, dbname, username, password)
      }

      # We can now save the dataset and the functions which is used to read and write the model
      super$initialize(model, saveRDS, readRDS, dataset)
      
      # If the file exists,
      if((!is.null(file)) && file.exists(file)) {
        # We can load the dataset
        self$model = self$load(file)
      } else {
        # otherwise, we can create it
        self$model = randomForest(as.factor(dataset$stats_label) ~ . , data = dataset$stats, subset = dataset$sample, ntree = ntree)
      }
      # At the end, if the file doesn't exist,
      if((!is.null(file)) && (!file.exists(file))) {
        # we will save the model
        self$save(file)
      }
    },

    predict = function(validation = FALSE) {
      # We will predict either the test set or the validation set 
      if(validation == FALSE) {
        private$pred = c(predict(self$model, newdata = self$test, type="response"))-1 
      } else {
        private$pred = c(predict(self$model, newdata = self$validation, type="response"))-1 
      }
    },

    print = function() {
      # We will print the result i.e the confusion matrix
      if(!is.null(self$predict)) {
        print(confusionMatrix(private$pred, self$test_label))
      }
    }
  ),
  private = list(
    pred = NULL
  )
)
