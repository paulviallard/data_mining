#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)

rm(list=ls())
setwd("/Users/paulviallard/Universite/M1/S2/Data_Mining/Project/")

# We export the datasets from the database
source("proba/export.r")

# We compute the frequencies for the dataset with the bans and the champs
source("proba/freq.r", print.eval=TRUE)

# We compute the main role of the champs
source("proba/role.r")

# We compute the all means of the stats
source("proba/mean.r", print.eval=TRUE)
