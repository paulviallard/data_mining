#!/usr/bin/env Rscript

library(rpart)
library(rpart.plot)
library(caret)
source("model.r")


# This class represents the decision trees
ModelTree = R6Class("ModelTree",
  inherit = Model,
  public = list(
    initialize = function(parms = list(split = 'information'), minsplit = 2, minbucket = 1, cp = 0, grid_search = FALSE, grid_file = NULL, try=10, file=NULL, dataset = NULL, dbname = "lol", username = "root", password = "") {

      # We initialize the parameters for the model
      private$parms = parms
      private$minsplit = minsplit
      private$minbucket = minbucket
      private$cp = cp
      private$grid_file = grid_file
      private$try = try
      private$file = file
      model = NULL

      # If we don't have a dataset, we will create it
      if(is.null(dataset)) {
        dataset = DatasetStats(dataset, dbname, username, password)
      }

      # We create the model object
      super$initialize(model, saveRDS, readRDS, dataset)
      
      # We will load the model if the file exists
      if((!is.null(file)) && file.exists(file)) {
        self$model = self$load(file)
      } else {
        # If we want to compute one tree
        if(grid_search == FALSE) {
          # We will compute it with the parameters given 
          self$model = rpart(self$label ~ ., data = self$data, subset = dataset$sample, method = "class", parms = parms, minsplit = minsplit, minbucket = minbucket, cp=cp)
        } else {
          # Otherwise, we will perform a grid search
          self$model = private$grid_search(dataset)
        }
      }
      # If the file doesn't exist, we will create it
      if((!is.null(file)) && (!file.exists(file))) {
        self$save(file)
      }
    },

    predict = function(model=NULL, validation = FALSE) {
      # We will predict the model either on the test or validation set
      if(is.null(model)) {
        model = self$model
      }
      if(validation == FALSE) {
        private$pred = predict(model, newdata = self$test, type="vector")-1 
      } else {
        private$pred = predict(model, newdata = self$validation, type="vector")-1 
      }
    },

    print = function() {
      # We print the decision tree
      prp(self$model)
    },

    print_result = function(pred=NULL, validation=FALSE) {
      # We print the confusion matrix either for the validation or the test set
      if(!is.null(private$pred)) {
        if(validation == FALSE) {
          print(confusionMatrix(private$pred, self$test_label))
        } else {
          print(confusionMatrix(private$pred, self$validation_label))
        }
      }
    },

    print_result_grid_search = function() {
      # We will print the result of the grid search
      if(!is.null(private$grid_file)) {
        result = private$read(private$grid_file)
        print(head(result))
        plot = ggplot(result, aes(x=cp, y=accuracy))
        plot = plot + geom_line() 
        plot = plot + labs(x = "Complexity", y = "Accuracy")
        plot = plot + theme_bw() 
        plot
      }
    }
  ),

  private = list(
    dataset = NULL,
    parms = NULL,
    minsplit = NULL,
    minbucket = NULL,
    cp = NULL,
    grid_file = NULL,
    try = NULL,
    file = NULL,
    pred = NULL,

    grid_search = function(dataset) {
      # We will perform a grid search in order to find the best complexity
      
      # We create the list of complexity that we have to test
      cp_list = seq(0, 1, length.out = private$try)
      # We create the history
      cp_history = data.frame(matrix(0, nrow = private$try, ncol = 2))
      colnames(cp_history) = c("cp", "accuracy")
      
      # We will create the list of models that we inferred
      model_list = vector(mode="list", length=private$try)
      max = 0.0
      argmax = -1

      # For each complexity cp that we have to test
      i = 1
      for (cp in cp_list) {
        # We infer a model
        model_list[[i]] = rpart(self$label ~ ., data = self$data, subset = self$sample, method = "class", parms = private$parms, minsplit = private$minsplit, minbucket = private$minbucket, cp=cp)

        # We predict the labels of the examples in the validation set
        self$predict(model=model_list[[i]], validation=TRUE)
        # We get the accuracy
        confusion = confusionMatrix(private$pred, self$validation_label)
        accuracy = as.numeric(confusion$overall['Accuracy'])
        cp_history[i,] = c(cp, accuracy)

        # and we keep the best accuracy we had
        print(accuracy)
        if(accuracy >= max) {
          max = accuracy
          argmax = i
        }
        i = i + 1 
      }
      # We save the results 
      if(!is.null(private$grid_file)) {
        private$write(cp_history, private$grid_file)
      }
      # We return the model where the accuracy was at its maximum
      model_list[[argmax]]
    },

    

    read = function(path) {
      # We will write a file
      file = NA
      if(file.exists(path)) {
        file = read.csv(path, row.names = 1)
      }
      file
    },

    write = function(data, file) {
      # We will write a dataset
      write.csv(data, file)
    }
  )
)
