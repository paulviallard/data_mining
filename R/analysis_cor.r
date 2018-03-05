#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)


# The class AnalysisCor represents the analysis of the correlation matrix
AnalysisCor = R6Class("AnalysisCor",
  public = list(
    initialize = function(dataset) {
      # We store the dataset
      private$dataset = dataset
      stats_label = data.frame(private$dataset$stats_label)
      colnames(stats_label) = c("win")
      private$dataset = cbind(stats_label, private$dataset$stats)
    },

    print_team = function(team = 1) {
      # We print the correlation matrix of the team
      if(team == 1 || team == 2) {
        vec = paste(private$vector_team, "_", as.character(team), sep="")
        private$print(vec)
      }
    },

    print_player = function(team = 1, role = "top") {
      # We print the correlation matrix of a role in a team
      if(team == 1 || team == 2) {
        if(role == "top" || role == "mid" || role == "jungle" || role == "supp" || role == "carry") {
          vec = paste(private$vector_player, "_", role, "_", as.character(team), sep="")
          private$print(vec)
        }
      }
    }

  ),
  private = list(
    dataset = NULL,
    
    # We get the columns for the correlation matrix of the team 
    vector_team = c("firstblood", "firsttower", "firstinhib", "firstbaron", "firstdragon", "firstharry", "towerkills", "inhibkills", "baronkills", "dragonkills", "harrykills"),

    # We get the columns for the correlation matrix of a role in a team
    vector_player = c("kills", "deaths", "assists", "largestkillingspree", "largestmultikill", "killingsprees", "longesttimespentliving", "doublekills", "triplekills", "quadrakills", "pentakills", "totdmgdealt", "magicdmgdealt", "physicaldmgdealt", "truedmgdealt", "largestcrit", "totdmgtochamp", "magicdmgtochamp", "physdmgtochamp", "truedmgtochamp", "totheal", "totunitshealed", "dmgselfmit", "dmgtoobj", "dmgtoturrets", "visionscore", "totdmgtaken", "magicdmgtaken", "physdmgtaken", "truedmgtaken", "goldearned", "goldspent", "turretkills", "inhibkills", "totminionskilled", "neutralminionskilled", "ownjunglekills", "enemyjunglekills", "totcctimedealt", "champlvl", "pinksbought", "wardsplaced", "wardskilled", "firstblood"),
    print = function (vec) {
      # We will print the correlation matrix
      # We create the correlation matrix

      cor = cor(private$dataset[,c("win", vec)])
      melt = melt(cor)

      # and we plot it
      plot = ggplot(melt, aes(Var1, Var2, fill = value, label = round(value, 1)))
      plot = plot + geom_tile() 
      plot = plot + geom_text(size = 2)
      plot = plot + theme(text = element_text(size=5), axis.text.x = element_text(angle = 90, hjust = 1))
      plot
    }
  )
)


