#!/usr/bin/env Rscript

library(class)

model.create_model = function(fun) {
  if(!file.exists(model.file)) {
    model.final = fun
    saveRDS(model.final, model.file)
  } else {
    model.final = readRDS(model.file) 
  }
  model.final
}

# We sample the dataset
dataset_stats.nrow = nrow(dataset_stats.data)
dataset_stats.sample = sort(sample(1:dataset_stats.nrow, floor(dataset_stats.nrow/2)))
dataset_stats.train = dataset_stats.data[dataset_stats.sample, ]
dataset_stats.test = dataset_stats.data[-dataset_stats.sample,]
dataset_stats.train_label = dataset_stats.label[dataset_stats.sample]
dataset_stats.test_label = dataset_stats.label[-dataset_stats.sample]

# 
dataset_stats.knn_predict = knn(dataset_stats.train, dataset_stats.test, dataset_stats.train_label, k = 1)

confusionMatrix(dataset_stats.knn_predict, dataset_stats.test_label)
