#!/usr/bin/env Rscript

# We compute a PCA on the dataset 
dataset_stats.pca = princomp(dataset_stats.data, scores = TRUE)

# We get the result of the PCA
dataset_stats.scores = as.data.frame(dataset_stats.pca$scores)

# We take the 3 components
dataset_stats.comp1 = dataset_stats.pca$loadings[,1]*dataset_stats.pca$sdev[1] 
dataset_stats.comp2 = dataset_stats.pca$loadings[,2]*dataset_stats.pca$sdev[2]
dataset_stats.comp3 = dataset_stats.pca$loadings[,3]*dataset_stats.pca$sdev[3]
dataset_stats.comp_zero = rep(0, length(dataset_stats.comp1))
dataset_stats.comp = data.frame(dataset_stats.comp1,dataset_stats.comp2,dataset_stats.comp3, dataset_stats.comp_zero)
colnames(dataset_stats.comp) = c("comp1", "comp2", "comp3", "zero")

# We project our dataset in 2D
ggplot(dataset_stats.scores, aes(Comp.1, Comp.2, color = as.factor(dataset_stats.label))) + geom_point() + labs(x = "Component 1", y = "Component 2", color = "Label")

# We plot the eigenvectors in 2D
ggplot(dataset_stats.comp, aes(zero, zero, label = as.character(row.names(dataset_stats.comp)))) + geom_segment(aes(xend=comp1, yend=comp2), size=0.1, arrow = arrow(length = unit(0.2,"cm"))) + geom_text(aes(comp1, comp2))  + labs(x = "Component 1", y = "Component 2")

# We project our dataset in 3D
dataset_stats.label2 = lapply(dataset_stats.label, function(x) { x+1 })
dataset_stats.label2 = unlist(dataset_stats.label2)
plot3d(dataset_stats.scores$Comp.1, dataset_stats.scores$Comp.2, dataset_stats.scores$Comp.3, xlab="Component 1", ylab="Component 2", zlab="Component 3", col=dataset_stats.label2)
