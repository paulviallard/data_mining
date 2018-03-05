#!/usr/bin/env Rscript

library(e1071)
library(caret)
source("model.r")

# The class ModelSVM will represent the SVM model
ModelSVM = R6Class("ModelSVM",
  inherit = Model,
  public = list(
    initialize = function(file=NULL, dataset = NULL, dbname = "lol", username = "root", password = "") {
      # We will create the model
      model = NULL
      # If we don't have the dataset
      if(is.null(dataset)) {
        # we can create it
        dataset = DatasetStats(dataset, dbname, username, password)
      }

      # We initialize the model object
      super$initialize(model, saveRDS, readRDS, dataset)
      
      # If we have a file of the SVM model,
      if((!is.null(file)) && file.exists(file)) {
        # we can load it
        self$model = self$load(file)
      } else {
        # otherwise, we will train the SVM
        self$model = svm(as.factor(self$train_label) ~ ., data=self$train, kernel="linear")
      }
      # If we have a file, we will save it
      if((!is.null(file)) && (!file.exists(file))) {
        self$save(file)
      }
    },

    predict = function(validation = FALSE) {
      # We will predict the examples either in the test set or in the validation set
      if(validation == FALSE) {
        private$pred = predict(self$model, newdata = self$test, type="class")-1 
      } else {
        private$pred = predict(self$model, newdata = self$validation, type="class")-1 
      }
    },

    print = function() {
      # We will print the confusion matrix
      if(!is.null(private$pred)) {
        print(confusionMatrix(private$pred, self$test_label))
      }
    }
  ),
  private = list(
    pred = NULL
  )
)
