#!/usr/bin/env Rscript

library(ggplot2)
library(rgl)
library(reshape2)


# The class AnalysisPCA represents the PCA analysis 
AnalysisPCA = R6Class("AnalysisPCA",
  public = list(
    initialize = function(dataset) {
      # We initialize the class in taking the components needed to project the data 
      private$dataset = dataset
      # We compute the PCA
      private$pca = princomp(private$dataset$stats, scores = TRUE)
      # We take the new points
      private$scores = as.data.frame(private$pca$scores)
   
      # We take 3 components to project our data in 2D or 3D 
      comp1 = private$pca$loadings[,1]*private$pca$sdev[1] 
      comp2 = private$pca$loadings[,2]*private$pca$sdev[2]
      comp3 = private$pca$loadings[,3]*private$pca$sdev[3]
      comp_zero = rep(0, length(comp1))
      # We create a dataset with the components
      private$comp = data.frame(comp1,comp2,comp3,comp_zero)
      colnames(private$comp) = c("comp1", "comp2", "comp3", "zero")
    },

    print_2D = function() {
      # We project our data in 2D 
      plot = ggplot(private$scores, aes(Comp.1, Comp.2, color = as.factor(private$dataset$stats_label)))
      plot = plot + geom_point() 
      plot = plot + labs(x = "Component 1", y = "Component 2", color = "Label")
      plot = plot + scale_colour_manual(values = c("black", "red"))
      plot = plot + theme_bw() 
      plot
    },

    print_vectors = function() {
      # We plot the eigenvectors 
      plot = ggplot(private$comp, aes(zero, zero, label = as.character(row.names(private$comp))))
      plot = plot + geom_segment(aes(xend=comp1, yend=comp2), size=0.1, arrow = arrow(length = unit(0.2,"cm")))
      plot = plot + geom_text(aes(comp1, comp2), size=2) 
      plot = plot + labs(x = "Component 1", y = "Component 2")
      plot = plot + theme_bw() 
      plot
    },

    print_3D = function() {
      # We project the data in 3D
      label = lapply(private$dataset$stats_label, function(x) { x+1 })
      label = unlist(label)
      
      plot3d(private$scores$Comp.1, private$scores$Comp.2, private$scores$Comp.3, xlab="Component 1", ylab="Component 2", zlab="Component 3", col=label)
    }

  ),
  private = list(
    dataset = NULL,
    pca = NULL,
    scores = NULL,
    comp = NULL
  )
)

