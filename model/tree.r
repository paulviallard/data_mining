#!/usr/bin/env Rscript

model.create_model = function(fun) {
  if(!file.exists(model.file)) {
    model.final = fun
    saveRDS(model.final, model.file)
  } else {
    model.final = readRDS(model.file) 
  }
  model.final
}

dataset.sample = function(fun) {
  if(file.exists(dataset.file)) {
    sample = read.csv(dataset.file)
    sample = sample[1:nrow(sample),]
  } else {
    sample = fun
    write.csv(sample, file=dataset.file, row.names = FALSE)
  }
  sample
}

# We sample the dataset
dataset_stats.nrow = nrow(dataset_stats.data)

dataset.file = "dataset/sample_train.csv"
dataset_stats.sample = dataset.sample(sort(sample(1:dataset_stats.nrow, floor(0.6*dataset_stats.nrow))))

dataset_stats.train = as.matrix(dataset_stats.data[dataset_stats.sample, ])
dataset_stats.remain = dataset_stats.data[-dataset_stats.sample,]

dataset.file = "dataset/sample_validation_test.csv"
dataset_stats.sample_remain = dataset.sample(sort(sample(1:nrow(dataset_stats.remain), floor(0.5*nrow(dataset_stats.remain)))))

dataset_stats.validation = dataset_stats.remain[dataset_stats.sample_remain, ]
dataset_stats.test = dataset_stats.remain[-dataset_stats.sample_remain,]

dataset_stats.train_label = dataset_stats.label[dataset_stats.sample]
dataset_stats.remain_label = dataset_stats.label[-dataset_stats.sample]
dataset_stats.validation_label = dataset_stats.remain_label[dataset_stats.sample_remain]
dataset_stats.test_label = dataset_stats.remain_label[-dataset_stats.sample_remain]

# We create a tree where we split according to the entropy index
cp_list = seq(0, 1, length.out = 50)
dataset_stats.cp_history = data.frame(matrix(0, nrow = 50, ncol = 2))
colnames(dataset_stats.cp_history) = c("cp", "accuracy")
i = 1
for (cp in cp_list) {
  model.file = paste("model/tree_entropy_", cp, ".rds", sep="")
  dataset_stats.tree_entropy = model.create_model(rpart(dataset_stats.label ~ ., 
      data = dataset_stats.data,
      subset = dataset_stats.sample,
      method = "class",
      parms = list(split = 'information'), 
      minsplit = 2, 
      minbucket = 1,
      cp=cp))

  dataset_stats.predict = predict(dataset_stats.tree_entropy, newdata = dataset_stats.validation, type="vector")-1
  dataset_stats.confusion = confusionMatrix(dataset_stats.predict, dataset_stats.validation_label)
  dataset_stats.cp_history[i,] = c(cp, as.numeric(dataset_stats.confusion$overall['Accuracy']))
  print(as.numeric(dataset_stats.confusion$overall['Accuracy']))
  i = i + 1 
}
write.csv(dataset_stats.cp_history, "model/tree_entropy_cp.csv")


model.file = "model/tree_entropy_0.26530612244898.rds"
model.file = "model/tree_entropy_0.rds"
dataset_stats.tree_entropy = model.create_model(rpart(dataset_stats.label ~ ., 
      data = dataset_stats.data,
      subset = dataset_stats.sample,
      method = "class",
      parms = list(split = 'information'), 
      minsplit = 2, 
      minbucket = 1,
      cp=0.0))

# We create a tree where we split according to the gini index
model.file = "model/tree_gini.rds"
dataset_stats.tree_gini = model.create_model(rpart(dataset_stats.label ~ ., 
      data = dataset_stats.data,
      subset = dataset_stats.sample,
      method = "class",
      parms = list(split = 'gini'), 
      minsplit = 2, 
      minbucket = 1,
      cp=0.00))

# We create a forest 
model.file = "model/forest.rds"
dataset_stats.forest = model.create_model(randomForest(as.factor(dataset_stats.label) ~ . , data = dataset_stats.data , subset = dataset_stats.sample, ntree = 50))

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
