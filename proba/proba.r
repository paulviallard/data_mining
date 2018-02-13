#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)

rm(list=ls())
setwd("/Users/paulviallard/Universite/M1/S2/Data_Mining/Project/")

# We export the datasets from the database
source("proba/export.r")


# We compute the frequency of the apparition of the champions
dataset_champs.freq = as.data.frame(table(dataset_champs.data$name))
colnames(dataset_champs.freq) = c("Name", "Freq_Champs")
head(dataset_champs.freq)

# We compute the frequency of bans for the champions
dataset_bans.freq = as.data.frame(table(dataset_bans.data$name))
colnames(dataset_bans.freq) = c("Name", "Freq_Bans")
head(dataset_bans.freq)

# We will merge the two dataframe
dataset_freq.data = merge(dataset_champs.freq, dataset_bans.freq, by="Name")
head(dataset_freq.data)

# We will plot the dataframe
dataset_freq.melt = melt(dataset_freq.data)
ggplot(dataset_freq.melt, aes(x=Name, y=value, fill=variable)) + geom_bar(stat="identity", ) + coord_flip() + theme(legend.text=element_text(size=5)) + theme_bw(base_size=5)

# We can add a new column called interest
dataset_freq.data[,"Interest"] = dataset_freq.data[,"Freq_Champs"]+dataset_freq.data[,"Freq_Bans"]
head(dataset_freq.data)




dataset_stats.compute_mean = function() {
  # We compute the mean of the total damage 
  dataset_stats.rows = unique(dataset_stats.data$name)
  dataset_stats.mean = data.frame(matrix(0, nrow = length(dataset_stats.rows), ncol = length(dataset_stats.data)))
  row.names(dataset_stats.mean) = dataset_stats.rows
  colnames(dataset_stats.mean)[] = lapply(colnames(dataset_stats.data), function(x) { paste("mean_", x, sep="") })
  dataset_stats.mean["mean_name"] = NULL
  head(dataset_stats.mean)

  dataset_stats.rows = unique(dataset_stats.data$name)
  dataset_stats.size = data.frame(matrix(0, nrow = length(dataset_stats.rows), ncol = length(dataset_stats.data)))
  row.names(dataset_stats.size) = dataset_stats.rows
  colnames(dataset_stats.size)[] = lapply(colnames(dataset_stats.data), function(x) { paste("size_", x, sep="") })
  dataset_stats.size["size_name"] = NULL
  head(dataset_stats.size)


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
  write.csv(dataset_stats.mean, "Data/Understanding/dataset_stats_mean.csv")
  write.csv(dataset_stats.size, "Data/Understanding/dataset_stats_size.csv")
  dataset_stats.mean = dataset_stats.mean / dataset_stats.size
  dataset_stats.mean
}
dataset_stats.mean = dataset_stats.compute_mean()


dataset_stats.mean = read.csv("Data/Understanding/dataset_stats_mean.csv", row.names = 1)
dataset_stats.size = read.csv("Data/Understanding/dataset_stats_size.csv", row.names = 1)
row.names(dataset_stats.mean) = dataset_stats.rows

dataset_stats.mean = dataset_stats.mean[order(row.names(dataset_stats.mean)), ]
dataset_stats.mean["Name"] = row.names(dataset_stats.mean)
dataset_stats.mean["Name"] = NULL
head(dataset_stats.mean)
head(dataset_stats.size)


print(dataset_stats.mean)
write.csv(dataset_stats.mean, "Data/Understanding/proba_mean.csv")
dataset_stats.mean = read.csv("Data/Understanding/proba_mean.csv", row.names = 1)

dataset_stats.mean["Interest"] = NULL
dataset_stats.mean["Interest"] = dataset_freq.data[,"Interest"]
cor(dataset_stats.mean)

dataset_stats.cor = cor(dataset_stats.mean)
dataset_stats.cor = melt(dataset_stats.cor)

# Correlation matrix
ggplot(data = dataset_stats.cor, aes(x=Var1, y=Var2, fill=value)) + geom_tile()

# Plot all things with with interest
dataset_stats.mean.nrow = nrow(dataset_stats.mean)
for (i in 1:dataset_stats.mean.nrow) {
  ggsave(paste(colnames(dataset_stats.mean)[i], ".pdf", sep=""))
  ggplot(data = dataset_stats.mean, aes(x=mean_totminionskilled, y=Interest, label = rownames(dataset_stats.mean))) + geom_point()
  # unlink(paste(colnames(dataset_stats.mean)[i], ".pdf", sep=""))
}

ggplot(dataset_stats.mean, aes(x=Interest, y=mean_totdmgdealt)) + geom_point()
ggplot(dataset_stats.mean, aes(x=Interest, y=mean_totdmgtaken)) + geom_point()


ggplot(dataset_stats.mean, aes(x=Name, y=mean_totdmgdealt)) + geom_bar(stat="identity", ) + coord_flip() + theme(legend.text=element_text(size=5)) + theme_bw(base_size=5)



dataset_mean.melt = melt(dataset_stats.mean)
print(dataset_mean.melt)
ggplot(dataset_mean.melt, aes(x=Name, y=value, fill=variable)) + geom_bar(stat="identity", ) + coord_flip() + theme(legend.text=element_text(size=5)) + theme_bw(base_size=5)
