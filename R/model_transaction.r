#!/usr/bin/env Rscript

library(Matrix)
library(arules)

# The class will represent the result of the Apriori algorithm
ModelTransaction = R6Class("ModelTransaction",
  public = list(
    rule = NULL,
    initialize = function(dataset) {
      # We will compute the Apropri algorithm
      private$dataset = dataset
      self$compute()
    },
    
    compute = function (support=0.005, confidence=0.501) {
      # We perform the algorithm
      self$rule = apriori(private$dataset$transaction, parameter=list(support=support, confidence=confidence), appearance = list(rhs = c("Win", "Loose")))
    },
    
    print = function(conf = 0.53) {
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
