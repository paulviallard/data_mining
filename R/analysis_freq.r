#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)

# The class AnalysisFreq represents the analysis of the frequencies
AnalysisFreq = R6Class("AnalysisFreq",
  public = list(
    initialize = function(dataset) {
      # We create the two datasets in order to create the frequencies
      private$dataset = dataset
      
      # We create the dataset of the champions
      private$freq_champs = as.data.frame(table(private$dataset$champs$name))
      colnames(private$freq_champs) = c("Name", "Pick")
      
      # We create the dataset of the banned champions
      private$freq_bans = as.data.frame(table(private$dataset$bans$name))
      colnames(private$freq_bans) = c("Name", "Ban")

      # We merge the two datasets
      private$freq = merge(private$freq_champs, private$freq_bans, by="Name") 
    },

    print = function() {
      # We plot the dataset of frequencies
      melt = melt(private$freq)
      plot = ggplot(melt, aes(x=Name, y=value, fill=variable))
      plot = plot + labs(x = "Champion", y="Interest")
      plot = plot + scale_fill_discrete(name = "Interest")
      plot = plot + geom_bar(stat="identity", ) 
      plot = plot + coord_flip() 
      plot = plot + theme(legend.text=element_text(size=5))
      plot = plot + theme_bw(base_size=5)
      plot
    }
  ),
  private = list(
    dataset = NULL,
    freq = NULL,
    freq_champs = NULL,
    freq_bans = NULL
  )
)
