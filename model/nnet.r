#!/usr/bin/env Rscript

model.train = function(model) {
  dataset_stats.predict = evaluate(model, dataset_stats.validation, dataset_stats.validation_label, batch_size=dataset_stats.batch_size)
  dataset_stats.mesure_best = as.numeric(dataset_stats.predict$categorical_accuracy)

  if(file.exists(dataset_stats.file)) {
    model_file = load_model_hdf5(dataset_stats.file)
    dataset_stats.predict = evaluate(model_file, dataset_stats.validation, dataset_stats.validation_label, batch_size=dataset_stats.batch_size)
    dataset_stats.mesure_file = as.numeric(dataset_stats.predict$categorical_accuracy)

    if(dataset_stats.mesure_file > dataset_stats.mesure_best) {
      dataset_stats.mesure_best = dataset_stats.mesure_file
    }
  }

  dataset_stats.epoch_history = data.frame(matrix(0, nrow = dataset_stats.epoch, ncol = 2))
  colnames(dataset_stats.epoch_history) = c("epoch", "accuracy")


  for (i in 1:dataset_stats.epoch) { 
    fit(model, dataset_stats.train, dataset_stats.train_label, epochs = 1, batch_size = dataset_stats.batch_size)
    dataset_stats.predict = evaluate(dataset_stats.neural, dataset_stats.validation, dataset_stats.validation_label, batch_size=dataset_stats.batch_size)
    dataset_stats.mesure = as.numeric(dataset_stats.predict$categorical_accuracy)
 
    dataset_stats.epoch_history[i,] = c(i, dataset_stats.mesure)
    if(dataset_stats.mesure_best < dataset_stats.mesure) {
      save_model_hdf5(model, dataset_stats.file)
      dataset_stats.mesure_best = dataset_stats.mesure
      print(dataset_stats.mesure_best)
    } 
  }
  write.csv(dataset_stats.epoch_history, dataset_stats.history_file)
  model = load_model_hdf5(dataset_stats.file)
  model
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

dataset_stats.validation = as.matrix(dataset_stats.remain[dataset_stats.sample_remain, ])
dataset_stats.test = as.matrix(dataset_stats.remain[-dataset_stats.sample_remain,])

dataset_stats.train_label = to_categorical(as.matrix(dataset_stats.label[dataset_stats.sample]))
dataset_stats.remain_label = dataset_stats.label[-dataset_stats.sample]
dataset_stats.validation_label = to_categorical(as.matrix(dataset_stats.remain_label[dataset_stats.sample_remain]))
dataset_stats.test_label = to_categorical(as.matrix(dataset_stats.remain_label[-dataset_stats.sample_remain]))


# We normalize the data to converge quickly
dataset_stats.train = normalize(dataset_stats.train)
dataset_stats.validation = normalize(dataset_stats.validation)
dataset_stats.test = normalize(dataset_stats.test)


dataset_stats.neural = keras_model_sequential()
dataset_stats.neural %>% 
  layer_dense(units = 1000, input_shape = c(473)) %>%
  layer_activation('relu') %>%
  layer_dense(units = 400) %>%
  layer_activation('relu') %>% 
  layer_dense(units = 2) %>%
  layer_activation('softmax')

dataset_stats.neural_adam = compile(dataset_stats.neural, optimizer = 'adam', loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))
dataset_stats.neural_rmsprop = compile(dataset_stats.neural, optimizer = 'rmsprop', loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))
dataset_stats.neural_adagrad = compile(dataset_stats.neural, optimizer = 'adagrad', loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))
dataset_stats.neural_adadelta = compile(dataset_stats.neural, optimizer = 'adadelta', loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))


dataset_stats.history_file = "model/neural_epoch_adam.csv"
dataset_stats.file = "model/neural_adam.hdf5"
dataset_stats.epoch = 50
dataset_stats.batch_size = 30
dataset_stats.neural_adam = model.train(dataset_stats.neural_adam)
dataset_stats.predict = evaluate(dataset_stats.neural_adam, dataset_stats.test, dataset_stats.test_label, batch_size=dataset_stats.batch_size)

dataset_stats.history_file = "model/neural_epoch_rmsprop.csv"
dataset_stats.file = "model/neural_rmsprop.hdf5"
dataset_stats.epoch = 50
dataset_stats.batch_size = 30
dataset_stats.neural_rmsprop = model.train(dataset_stats.neural_rmsprop)
dataset_stats.predict = evaluate(dataset_stats.neural_rmsprop, dataset_stats.test, dataset_stats.test_label, batch_size=dataset_stats.batch_size)

dataset_stats.history_file = "model/neural_epoch_adagrad.csv"
dataset_stats.file = "model/neural_adagrad.hdf5"
dataset_stats.epoch = 50
dataset_stats.batch_size = 30
dataset_stats.neural_adagrad = model.train(dataset_stats.neural_adagrad)
dataset_stats.predict = evaluate(dataset_stats.neural_adagrad, dataset_stats.test, dataset_stats.test_label, batch_size=dataset_stats.batch_size)

dataset_stats.history_file = "model/neural_epoch_adadelta.csv"
dataset_stats.file = "model/neural_adadelta.hdf5"
dataset_stats.epoch = 50
dataset_stats.batch_size = 30
dataset_stats.neural_adadelta = model.train(dataset_stats.neural_adadelta)
dataset_stats.predict = evaluate(dataset_stats.neural_adadelta, dataset_stats.test, dataset_stats.test_label, batch_size=dataset_stats.batch_size)

# We will test now the CNN
dataset_stats.neural_cnn = keras_model_sequential()
dataset_stats.neural_cnn %>% 
  layer_reshape(c(473, 1), input_shape=c(473)) %>%
  layer_conv_1d(1000, 5) %>%
  layer_activation('relu') %>%
  layer_average_pooling_1d() %>%
  layer_flatten() %>%
  layer_dense(units = 2) %>%
  layer_activation('softmax')

dataset_stats.neural_cnn_adam = compile(dataset_stats.neural_cnn, optimizer = 'adam', loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))
dataset_stats.neural_cnn_rmsprop = compile(dataset_stats.neural_cnn, optimizer = 'rmsprop', loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))
dataset_stats.neural_cnn_adagrad = compile(dataset_stats.neural_cnn, optimizer = 'adagrad', loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))
dataset_stats.neural_cnn_adadelta = compile(dataset_stats.neural_cnn, optimizer = 'adadelta', loss = 'categorical_crossentropy', metrics = c('categorical_accuracy'))

dataset_stats.history_file = "model/neural_cnn_epoch_adam.csv"  
dataset_stats.file = "model/neural_cnn_adam.hdf5"
dataset_stats.epoch = 50
dataset_stats.batch_size = 30
dataset_stats.neural_cnn_adam = model.train(dataset_stats.neural_cnn_adam)
dataset_stats.predict = evaluate(dataset_stats.neural_cnn_adam, dataset_stats.test, dataset_stats.test_label, batch_size=dataset_stats.batch_size)

dataset_stats.history_file = "model/neural_cnn_epoch_rmsprop.csv"  
dataset_stats.file = "model/neural_cnn_rmsprop.hdf5"
dataset_stats.epoch = 50
dataset_stats.batch_size = 30
dataset_stats.neural_cnn_rmsprop = model.train(dataset_stats.neural_cnn_rmsprop)
dataset_stats.predict = evaluate(dataset_stats.neural_cnn_rmsprop, dataset_stats.test, dataset_stats.test_label, batch_size=dataset_stats.batch_size)

dataset_stats.history_file = "model/neural_cnn_epoch_adagrad.csv"  
dataset_stats.file = "model/neural_cnn_adagrad.hdf5"
dataset_stats.epoch = 50
dataset_stats.batch_size = 30
dataset_stats.neural_cnn_adagrad = model.train(dataset_stats.neural_cnn_adagrad)
dataset_stats.predict = evaluate(dataset_stats.neural_cnn_adagrad, dataset_stats.test, dataset_stats.test_label, batch_size=dataset_stats.batch_size)
