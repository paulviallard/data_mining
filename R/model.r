#!/usr/bin/env Rscript

# The class Model represents a model
Model = R6Class("Model",
  public = list( 
    model = NULL,
    
    data = NULL,
    label = NULL,

    train = NULL, 
    validation = NULL,
    test = NULL,

    train_label = NULL, 
    validation_label = NULL,
    test_label = NULL,

    initialize = function(model = NULL, save_fun, load_fun, dataset = NULL, dbname = "lol", username = "root", password = "") {
      # We store the functions which can be saved and load the model
      private$save_fun = save_fun
      private$load_fun = load_fun
      
      # We store the model
      self$model = model
      
      if(is.null(dataset)) {
        # We create a dataset object if we have no dataset
        dataset = DatasetStats(dataset, dbname, username, password)
      }
      # We store the data and the label in the object
      self$data = dataset$stats
      self$label = dataset$stats_label
      
      # We store the splited version
      self$train = dataset$train
      self$validation = dataset$validation
      self$test = dataset$test
      
      self$train_label = dataset$train_label
      self$validation_label = dataset$validation_label
      self$test_label = dataset$test_label
    },

    save = function(file) {
      # The function will save the model in a file
      private$save_fun(self$model, file)
    },

    load = function(file) {
      # The function will load the model from a file
      private$load_fun(file)
    }
  ),

  private = list(
    save_fun = NULL,
    load_fun = NULL
  )
)
