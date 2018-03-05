#!/usr/bin/env Rscript

library(keras)
source("model.r")

# This class will represent the neural networks
ModelNNet = R6Class("ModelNNet",
  inherit = Model,
  public = list(
    initialize = function(model, batch_size = 30, optimizer = "adam", file=NULL, train_file = NULL, dataset = NULL, dbname = "lol", username = "root", password = "") { 
      # If the dataset is null,
      if(is.null(dataset)) {
        # we will create the dataset
        dataset = DatasetStats(dataset, dbname, username, password)
      }
     
      # We set the batch size, the optimizer that we will use,
      # the file where we will save the model and the file where we 
      # will save the training of the model
      private$batch_size = batch_size
      private$optimizer = optimizer
      private$file = file
      private$train_file = train_file

      # We will initialize the model object
      super$initialize(model, save_model_hdf5, load_model_hdf5, dataset, dbname, username, password)
      
      # If the file exists,
      if((!is.null(file)) && file.exists(file)) {
        # We will load the model
        self$model = self$load(file)
      }
      self$model = private$compile(self$model)
      

      # We normalize our data
      self$train = normalize(as.matrix(self$train))
      self$validation = normalize(as.matrix(self$validation))
      self$test = normalize(as.matrix(self$test))

      # We convert the label as categorial 
      self$train_label = to_categorical(as.matrix(self$train_label))
      self$validation_label = to_categorical(as.matrix(self$validation_label))
      self$test_label = to_categorical(as.matrix(self$test_label))
    },

    predict = function(validation = FALSE) {
      # We predict the new label in the test or in the validation set
      if(validation == TRUE) {
        private$pred = evaluate(self$model, self$validation, self$validation_label, batch_size=private$batch_size)
      } else {
        private$pred = evaluate(self$model, self$test, self$test_label, batch_size=private$batch_size)
      }
    }, 
    
    get_accuracy = function() {
      # We get the accuracy of the model
      as.numeric(private$pred$categorical_accuracy)
    },

    get_result_train = function() {
      # We get the result of the training
      if(!is.null(train_file)) {
        result = private$read(self$train_file)
      }
    },

    train_model = function(epoch = 1) {
      # We will train the model 

      # We will predict the examples in the validation set to 
      # initialize the accuracy
      self$predict(validation = TRUE)
      accuracy_best = self$get_accuracy() 

      # If a file exist we can take the model 
      # as reference for the accuracy 
      if((!is.null(private$file)) && file.exists(private$file)) {
        model_file = self$load(private$file)
        self$predict(validation = TRUE)
        accuracy = self$get_accuracy() 
        
        if(accuracy > accuracy_best) {
          accuracy_best = accuracy
        }
      }

      # We will store the epoch history
      epoch_history = data.frame(matrix(0, nrow = epoch, ncol = 2))
      colnames(epoch_history) = c("epoch", "accuracy")

      # For each epoch,
      for (i in 1:epoch) {
        # We will fit the model with the train set
        fit(self$model, self$train, self$train_label, epochs = 1, batch_size = private$batch_size)
        # We will now predict the examples in the validation set
        self$predict(validation = TRUE)
        # and get the accuracy
        accuracy = self$get_accuracy() 
 
        # We will save the new model if the accuracy is good
        # in the validation set
        epoch_history[i,] = c(i, accuracy)
        if(accuracy_best < accuracy) {
          self$save(private$file)
          accuracy_best = accuracy
          print(accuracy_best)
        } 
      }
      # We will also save the epoch history if a file is given
      if(!is.null(self$train_file)) {
        private$write(epoch_history, self$train_file)
      }
      # And load the best model that we had 
      model = self$load(private$file)
      model
    }
  ),
  private = list(
    batch_size = NULL,
    optimizer = NULL,
    file = NULL,
    train_file = NULL,
    pred = NULL,
    compile = function(model) {
      # We compile the model with a given optimizer
      compile(model, optimizer = private$optimizer, loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))
    }
  )
)
