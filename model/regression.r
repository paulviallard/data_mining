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

# We sample the dataset
dataset_stats.nrow = nrow(dataset_stats.data)
dataset_stats.sample = sort(sample(1:dataset_stats.nrow, floor(dataset_stats.nrow/2)))
dataset_stats.train = dataset_stats.data[dataset_stats.sample, ]
dataset_stats.test = dataset_stats.data[-dataset_stats.sample,]
dataset_stats.train_label = dataset_stats.label[dataset_stats.sample]
dataset_stats.test_label = dataset_stats.label[-dataset_stats.sample]

# We create the logistic regression 
model.file = "model/regression.rds"
dataset_stats.regression = model.create_model(glm(dataset_stats.train_label ~ ., data=dataset_stats.train,family=binomial()))

# # We get the prediction on the test set
dataset_stats.regression_predict = c(predict(dataset_stats.regression, data=dataset_stats.test, type="response"))
dataset_stats.regression_predict = lapply(dataset_stats.regression_predict, function(x) { if (x > 0.5) {1} else {0} })
dataset_stats.regression_predict = unlist(dataset_stats.regression_predict)

# We print the result of the model
confusionMatrix(dataset_stats.regression_predict, dataset_stats.test_label)
