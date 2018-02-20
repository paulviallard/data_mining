#!/usr/bin/env Rscript

dataset.freq.debug = function(data) {
  print("We computed the frequency")
  print(head(data))
}

dataset.merge.debug = function(data) {
  print("We merge the datasets")
  print(head(data))
}

# We compute the frequency of the apparition of the champions
dataset_champs.freq = as.data.frame(table(dataset_champs.data$name))
colnames(dataset_champs.freq) = c("Name", "Freq_Champs")
dataset.freq.debug(dataset_champs.freq)

# We compute the frequency of bans for the champions
dataset_bans.freq = as.data.frame(table(dataset_bans.data$name))
colnames(dataset_bans.freq) = c("Name", "Freq_Bans")
dataset.freq.debug(dataset_bans.freq)

# We will merge the two dataframe
dataset_freq.data = merge(dataset_champs.freq, dataset_bans.freq, by="Name")

# We prepare the dataset to be printed
dataset_freq.melt = melt(dataset_freq.data)

# We can now add a new column called interest
dataset_freq.data[,"Interest"] = dataset_freq.data[,"Freq_Champs"]+dataset_freq.data[,"Freq_Bans"]
head(dataset_freq.data)
dataset.merge.debug(dataset_freq.data)

# We will plot the dataframe
ggplot(dataset_freq.melt, aes(x=Name, y=value, fill=variable)) + geom_bar(stat="identity", ) + coord_flip() + theme(legend.text=element_text(size=5)) + theme_bw(base_size=5)
