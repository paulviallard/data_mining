#!/usr/bin/env Rscript

dataset.compute_accuracy = function(label, predicted) {
  label = c(label)
  predicted = c(predicted)
  sum(1-abs(label-predicted))/length(label)
}

# We sample the dataset
dataset_stats.nrow = nrow(dataset_stats.data)
dataset_stats.sample = sort(sample(1:dataset_stats.nrow, floor(dataset_stats.nrow/2)))
dataset_stats.train = dataset_stats.data[dataset_stats.sample, ]
dataset_stats.test = dataset_stats.data[-dataset_stats.sample,]
dataset_stats.train_label = dataset_stats.label[dataset_stats.sample]
dataset_stats.test_label = dataset_stats.label[-dataset_stats.sample]

# We split according to the entropy index
dataset_stats.tree_entropy = rpart(dataset_stats.label ~ ., 
      data = dataset_stats.data,
      subset = dataset_stats.sample,
      method = "class",
      parms = list(split = 'information'), 
      minsplit = 2, 
      minbucket = 1,
      cp=0.01)

# We split according to the gini index
dataset_stats.tree_gini = rpart(dataset_stats.label ~ ., 
      data = dataset_stats.data,
      subset = dataset_stats.sample,
      method = "class",
      parms = list(split = 'gini'), 
      minsplit = 2, 
      minbucket = 1,
      cp=0.01)


dataset_stats.forest = randomForest(as.factor(dataset_stats.label) ~ . , data = dataset_stats.data , subset = dataset_stats.sample, ntree = 50)

# We plot the decision tree made with the entropy
prp(dataset_stats.tree_entropy)

# We plot the decision tree made made with the gini index
prp(dataset_stats.tree_gini)

# We predict the example with the test set 
dataset_stats.tree_ent_predict = predict(dataset_stats.tree_entropy, newdata = dataset_stats.test, type="vector")-1
dataset_stats.tree_gini_predict = predict(dataset_stats.tree_gini, newdata = dataset_stats.test, type="vector")-1
dataset_stats.forest_predict = c(predict(dataset_stats.forest, newdata = dataset_stats.test, type="response"))-1

# We compute the accuracy of the two models
confusionMatrix(dataset_stats.tree_ent_predict, dataset_stats.test_label)
confusionMatrix(dataset_stats.tree_gini_predict, dataset_stats.test_label)
confusionMatrix(dataset_stats.forest_predict, dataset_stats.test_label)
