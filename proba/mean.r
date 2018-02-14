#!/usr/bin/env Rscript

dataset_stats.compute_mean = function() {
  if(!file.exists(dataset_stats.file)) {

    dataset_stats.rows = unique(dataset_stats.data$name)

    dataset_stats.mean = data.frame(matrix(0, nrow = length(dataset_stats.rows), ncol = length(dataset_stats.data)))
    dataset_stats.size = data.frame(matrix(0, nrow = length(dataset_stats.rows), ncol = length(dataset_stats.data)))
   
    row.names(dataset_stats.mean) = dataset_stats.rows
    row.names(dataset_stats.size) = dataset_stats.rows

    colnames(dataset_stats.mean)[] = lapply(colnames(dataset_stats.data), function(x) { paste("mean_", x, sep="") })
    colnames(dataset_stats.size)[] = lapply(colnames(dataset_stats.data), function(x) { paste("size_", x, sep="") })

    dataset_stats.mean["mean_name"] = NULL
    dataset_stats.size["size_name"] = NULL

    dataset_stats.nrow = nrow(dataset_stats.data)
    dataset_stats.ncol = ncol(dataset_stats.data)

    for (i in 1:dataset_stats.nrow) {
      # The first item will be the name of the champs
      dataset_stats.champs = as.character(dataset_stats.data[i, "name"])

      print(i)
      for (j in 2:dataset_stats.ncol) {
        dataset_stats.col = colnames(dataset_stats.data)[j]
        dataset_stats.mean_col = paste("mean_", dataset_stats.col, sep = "")
        dataset_stats.size_col = paste("size_", dataset_stats.col, sep = "")
        dataset_stats.size[dataset_stats.champs, dataset_stats.size_col] = dataset_stats.size[dataset_stats.champs, dataset_stats.size_col] + 1 
        dataset_stats.mean[dataset_stats.champs, dataset_stats.mean_col] = dataset_stats.mean[dataset_stats.champs, dataset_stats.mean_col] + dataset_stats.data[i, dataset_stats.col]
      }
    }
    dataset_stats.mean = dataset_stats.mean / dataset_stats.size
    write.csv(dataset_stats.mean, dataset_stats.file)
  } else {
    dataset_stats.mean = read.csv(dataset_stats.file, row.names = 1)
  }
  dataset_stats.mean
}

dataset_stats.file = "Data/Understanding/proba_mean.csv"
dataset_stats.mean = dataset_stats.compute_mean()
dataset_stats.mean = dataset_stats.mean[order(row.names(dataset_stats.mean)), ]
dataset_stats.mean["Interest"] = dataset_freq.data[,"Interest"]
cor(dataset_stats.mean)

dataset_stats.cor = cor(dataset_stats.mean)
dataset_stats.cor = melt(dataset_stats.cor)

# Add the role of the champs
dataset_stats.mean["Main"] = dataset_role.main[,"Main"]

dataset_stats.split = split(dataset_stats.mean, dataset_stats.mean$Main)

dataset_stats.split$Top["Main"] = NULL
dataset_stats.split$Mid["Main"] = NULL
dataset_stats.split$Jungle["Main"] = NULL
dataset_stats.split$Support["Main"] = NULL
dataset_stats.split$Carry["Main"] = NULL

dataset_stats.split$Top[,"mean_legendarykills"] = NULL
dataset_stats.split$Mid["mean_legendarykills"] = NULL
dataset_stats.split$Jungle["mean_legendarykills"] = NULL
dataset_stats.split$Support["mean_legendarykills"] = NULL

# zero standard deviation
dataset_stats.cor_top = cor(dataset_stats.split$Top)
dataset_stats.cor_top = melt(dataset_stats.cor_top)

dataset_stats.cor_mid = cor(dataset_stats.split$Mid)
dataset_stats.cor_mid
dataset_stats.cor_mid = melt(dataset_stats.cor_mid)

dataset_stats.cor_jungle = cor(dataset_stats.split$Jungle)
dataset_stats.cor_jungle = melt(dataset_stats.cor_jungle)

dataset_stats.cor_supp = cor(dataset_stats.split$Support)
dataset_stats.cor_supp = melt(dataset_stats.cor_supp)

dataset_stats.cor_carry = cor(dataset_stats.split$Carry)
dataset_stats.cor_carry
dataset_stats.cor_carry = melt(dataset_stats.cor_carry)

# Correlation matrix
ggplot(data = dataset_stats.cor, aes(x=Var1, y=Var2, fill=value)) + geom_tile() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggplot(data = dataset_stats.cor_top, aes(x=Var1, y=Var2, fill=value)) + geom_tile() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
ggplot(data = dataset_stats.cor_mid, aes(x=Var1, y=Var2, fill=value)) + geom_tile() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggplot(data = dataset_stats.cor_jungle, aes(x=Var1, y=Var2, fill=value)) + geom_tile() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggplot(data = dataset_stats.cor_supp, aes(x=Var1, y=Var2, fill=value)) + geom_tile() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggplot(data = dataset_stats.cor_carry, aes(x=Var1, y=Var2, fill=value)) + geom_tile() + theme(axis.text.x = element_text(angle = 90, hjust = 1))

# For Top: mean_quadrakills 0.7422612947 mean_pentakills 0.8077220380
for(i in 1:length(dataset_stats.split$Top)) {
  ggplot(data = dataset_stats.split$Top, aes_string(x=colnames(dataset_stats.split$Top)[i], y="Interest")) + geom_point()
  ggsave(paste(colnames(dataset_stats.split$Top)[i], ".png", sep=""))
}

# For Mid: mean_kills 0.507493538 mean_largestkillingspree 0.501520254
for(i in 1:length(dataset_stats.split$Mid)) {
  ggplot(data = dataset_stats.split$Mid, aes_string(x=colnames(dataset_stats.split$Mid)[i], y="Interest")) + geom_point()
  ggsave(paste(colnames(dataset_stats.split$Mid)[i], ".png", sep=""))
}

# For Jungle: mean_wardsplaced 0.575913205
for(i in 1:length(dataset_stats.split$Jungle)) {
  ggplot(data = dataset_stats.split$Jungle, aes_string(x=colnames(dataset_stats.split$Jungle)[i], y="Interest")) + geom_point()
  ggsave(paste(colnames(dataset_stats.split$Jungle)[i], ".png", sep=""))
}

# For Support: mean_totminionskilled -0.31190094 mean_truedmgtochamp 0.33198964 mean_totheal -0.32223231
for(i in 1:length(dataset_stats.split$Support)) {
  ggplot(data = dataset_stats.split$Support, aes_string(x=colnames(dataset_stats.split$Support)[i], y="Interest")) + geom_point()
  ggsave(paste(colnames(dataset_stats.split$Support)[i], ".png", sep=""))
}

# For Carry: mean_trinket 0.634273072
for(i in 1:length(dataset_stats.split$Carry)) {
  ggplot(data = dataset_stats.split$Carry, aes_string(x=colnames(dataset_stats.split$Carry)[i], y="Interest")) + geom_point()
  ggsave(paste(colnames(dataset_stats.split$Carry)[i], ".png", sep=""))
}
