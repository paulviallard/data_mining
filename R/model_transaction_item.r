#!/usr/bin/env Rscript

library(Matrix)
library(arules)

# The class will represent the result of the Apriori algorithm
ModelTransactionItem = R6Class("ModelTransactionItem",
  public = list(
    rule = NULL,
    initialize = function(dataset) {
      # We will compute the Apropri algorithm
      private$dataset = dataset
      self$compute()
    },
    
    compute = function (support=0.005, confidence=0.63) {
      # We perform the algorithm
      self$rule = apriori(private$dataset$transaction_item, parameter=list(support=support, confidence=confidence), appearance = list(rhs = c("win=Win", "win=Lose")))
    },
    
    print = function(conf = 0.5) {
      # We print the rules 
      if(!is.null(self$rule)) {
        inspect(sort(subset(self$rule, subset=confidence > conf), by="confidence"))
      }
    }
  ),
  
  private = list(
    dataset = NULL
  )
)
