#!/usr/bin/env Rscript

rm(list=ls())
setwd("/Users/paulviallard/Universite/M1/S2/Data_Mining/Project/R")

library(R6)

source("dataset_item.r")
source("dataset.r")
source("dataset_transaction.r")
source("dataset_transaction_item.r")
source("dataset_stats.r")

source("model_transaction.r")
source("model_transaction_item.r")

source("model_tree.r")
source("model_forest.r")
source("model_svm.r")
source("model_nnet.r")

source("analysis_freq.r")
source("analysis_pca.r")
source("analysis_cor.r")

# We load the dataset into the memory
dataset_item = DatasetItem$new()
dataset = Dataset$new()
dataset_transaction = DatasetTransaction$new(dataset)
dataset_transaction_item = DatasetTransactionItem$new(dataset)
dataset_stats = DatasetStats$new(dataset)

# We do a basket analysis on champions
model_transaction = ModelTransaction$new(dataset_transaction)
model_transaction$print()

# We do a basket analysis on items
model_transaction_item = ModelTransactionItem$new(dataset_transaction_item)
model_transaction_item$print()


# We analyse the frequencies
analysis_freq = AnalysisFreq$new(dataset)
analysis_freq$print()

# We project our data
analysis_pca = AnalysisPCA$new(dataset_stats)
analysis_pca$print_2D()
analysis_pca$print_vectors()
analysis_pca$print_3D()

# We train a tree with the entropy
model_tree_entropy = ModelTree$new(grid_search = TRUE, grid_file = "model/history_tree_info.csv", try=50, file="model/model_tree_info.rds", dataset=dataset_stats)
model_tree_entropy$print()
model_tree_entropy$predict()
model_tree_entropy$print_result()
model_tree_entropy$print_result_grid_search()

# We train a small tree
model_tree_small = ModelTree$new(cp=0.1, file="model/model_tree_small.rds", dataset=dataset_stats)
model_tree_small$print()
model_tree_small$predict()
model_tree_small$print_result()

# We train a tree with the gini index
model_tree_gini = ModelTree$new(parms = list(split = 'gini'), grid_search = TRUE, grid_file = "model/history_tree_gini.csv", try=50, file="model/model_tree_gini.rds", dataset=dataset_stats)
model_tree_gini$print()
model_tree_gini$predict()
model_tree_gini$print_result()
model_tree_gini$print_result_grid_search()

# We print some correlation matrices
analysis_cor = AnalysisCor$new(dataset_stats)
analysis_cor$print_team(team = 1)
analysis_cor$print_team(team = 2)

analysis_cor$print_player(team = 1, "top")
analysis_cor$print_player(team = 1, "mid")
analysis_cor$print_player(team = 1, "jungle")
analysis_cor$print_player(team = 1, "supp")
analysis_cor$print_player(team = 1, "carry")

analysis_cor$print_player(team = 2, "top")
analysis_cor$print_player(team = 2, "mid")
analysis_cor$print_player(team = 2, "jungle")
analysis_cor$print_player(team = 2, "supp")
analysis_cor$print_player(team = 2, "carry")

# We learn a random forest
model_forest = ModelForest$new(ntree = 50, file="model/model_forest.rds", dataset = dataset_stats)
model_forest$predict()
model_forest$print()
model_forest$print_importance(20)

# We learn a SVM
model_svm = ModelSVM$new(file="model/model_svm.rds", dataset = dataset_stats)
model_svm$predict()
model_svm$print()

# We train a feed forward network
mlp = keras_model_sequential()
mlp %>%
  layer_dense(units = 1000, input_shape = c(463)) %>%
  layer_activation('relu') %>%
  layer_dense(units = 400) %>%
  layer_activation('relu') %>%
  layer_dense(units = 2) %>%
  layer_activation('softmax')

model_mlp = ModelNNet$new(mlp, file="model/model_mlp.hdf5", train_file="model/history_mlp.csv", dataset=dataset_stats)
model_mlp$train_model(epoch=10)
model_mlp$predict()
model_mlp$get_accuracy()

# We train a CNN
cnn = keras_model_sequential()
cnn %>% 
  layer_reshape(c(463, 1), input_shape=c(463)) %>%
  layer_conv_1d(1000, 5) %>%
  layer_activation('relu') %>%
  layer_average_pooling_1d() %>%
  layer_flatten() %>%
  layer_dense(units = 2) %>%
  layer_activation('softmax')
model_cnn = ModelNNet$new(cnn, file="model/model_cnn.hdf5", train_file="model/history_cnn.csv", dataset=dataset_stats)
model_cnn$train_model(epoch=10)
model_cnn$predict()
model_cnn$get_accuracy()
