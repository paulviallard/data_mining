#!/usr/bin/env Rscript

# We sample the dataset
dataset_stats.nrow = nrow(dataset_stats.data)
dataset_stats.sample = sort(sample(1:dataset_stats.nrow, floor(dataset_stats.nrow/2)))
dataset_stats.train = dataset_stats.data[dataset_stats.sample, ]
dataset_stats.test = dataset_stats.data[-dataset_stats.sample,]
dataset_stats.train_label = dataset_stats.label[dataset_stats.sample]
dataset_stats.test_label = dataset_stats.label[-dataset_stats.sample]

dataset_stats.svm = svm(dataset_stats.train_label ~ ., data=dataset_stats.train)

dataset_stats.svm_predict = predict(dataset_stats.tree_entropy, newdata = dataset_stats.test, type="vector")-1

confusionMatrix(dataset_stats.tree_ent_predict, dataset_stats.test_label)
