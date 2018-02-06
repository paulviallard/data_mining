#!/usr/bin/env Rscript

library(DBI)
library(RMySQL)

rm(list=ls())
setwd("/Users/paulviallard/Universite/M1/S2/Data_Mining/Project/")

dataset.conn = dbConnect(MySQL(), dbname="lol", username="root", password="")

