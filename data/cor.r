#!/usr/bin/env Rscript

dataset_stats.data_match = dataset_stats.data[,c("firstblood_1", "firsttower_1", "firstinhib_1", "firstbaron_1", "firstdragon_1", "firstharry_1", "towerkills_1", "inhibkills_1", "baronkills_1", "dragonkills_1", "harrykills_1")]
dataset_stats.data_match[,"win"] = dataset_stats.label

dataset_stats.data_carry = dataset_stats.data[,c("trinket_carry_1", "kills_carry_1", "deaths_carry_1", "assists_carry_1", "largestkillingspree_carry_1", "largestmultikill_carry_1", "killingsprees_carry_1", "longesttimespentliving_carry_1", "doublekills_carry_1", "triplekills_carry_1", "quadrakills_carry_1", "pentakills_carry_1", "totdmgdealt_carry_1", "magicdmgdealt_carry_1", "physicaldmgdealt_carry_1", "truedmgdealt_carry_1", "largestcrit_carry_1", "totdmgtochamp_carry_1", "magicdmgtochamp_carry_1", "physdmgtochamp_carry_1", "truedmgtochamp_carry_1", "totheal_carry_1", "totunitshealed_carry_1", "dmgselfmit_carry_1", "dmgtoobj_carry_1", "dmgtoturrets_carry_1", "visionscore_carry_1", "totdmgtaken_carry_1", "magicdmgtaken_carry_1", "physdmgtaken_carry_1", "truedmgtaken_carry_1", "goldearned_carry_1", "goldspent_carry_1", "turretkills_carry_1", "inhibkills_carry_1", "totminionskilled_carry_1", "neutralminionskilled_carry_1", "ownjunglekills_carry_1", "enemyjunglekills_carry_1", "totcctimedealt_carry_1", "champlvl_carry_1", "pinksbought_carry_1", "wardsplaced_carry_1", "wardskilled_carry_1", "firstblood_carry_1")]
dataset_stats.data_carry[,"win"] = dataset_stats.label

dataset_stats.data_supp = dataset_stats.data[,c("trinket_supp_1", "kills_supp_1", "deaths_supp_1", "assists_supp_1", "largestkillingspree_supp_1", "largestmultikill_supp_1", "killingsprees_supp_1", "longesttimespentliving_supp_1", "doublekills_supp_1", "triplekills_supp_1", "quadrakills_supp_1", "pentakills_supp_1", "totdmgdealt_supp_1", "magicdmgdealt_supp_1", "physicaldmgdealt_supp_1", "truedmgdealt_supp_1", "largestcrit_supp_1", "totdmgtochamp_supp_1", "magicdmgtochamp_supp_1", "physdmgtochamp_supp_1", "truedmgtochamp_supp_1", "totheal_supp_1", "totunitshealed_supp_1", "dmgselfmit_supp_1", "dmgtoobj_supp_1", "dmgtoturrets_supp_1", "visionscore_supp_1", "totdmgtaken_supp_1", "magicdmgtaken_supp_1", "physdmgtaken_supp_1", "truedmgtaken_supp_1", "goldearned_supp_1", "goldspent_supp_1", "turretkills_supp_1", "inhibkills_supp_1", "totminionskilled_supp_1", "neutralminionskilled_supp_1", "ownjunglekills_supp_1", "enemyjunglekills_supp_1", "totcctimedealt_supp_1", "champlvl_supp_1", "pinksbought_supp_1", "wardsplaced_supp_1", "wardskilled_supp_1", "firstblood_supp_1")]
dataset_stats.data_supp[,"win"] = dataset_stats.label

dataset_stats.data_mid = dataset_stats.data[,c("trinket_mid_1", "kills_mid_1", "deaths_mid_1", "assists_mid_1", "largestkillingspree_mid_1", "largestmultikill_mid_1", "killingsprees_mid_1", "longesttimespentliving_mid_1", "doublekills_mid_1", "triplekills_mid_1", "quadrakills_mid_1", "pentakills_mid_1", "totdmgdealt_mid_1", "magicdmgdealt_mid_1", "physicaldmgdealt_mid_1", "truedmgdealt_mid_1", "largestcrit_mid_1", "totdmgtochamp_mid_1", "magicdmgtochamp_mid_1", "physdmgtochamp_mid_1", "truedmgtochamp_mid_1", "totheal_mid_1", "totunitshealed_mid_1", "dmgselfmit_mid_1", "dmgtoobj_mid_1", "dmgtoturrets_mid_1", "visionscore_mid_1", "totdmgtaken_mid_1", "magicdmgtaken_mid_1", "physdmgtaken_mid_1", "truedmgtaken_mid_1", "goldearned_mid_1", "goldspent_mid_1", "turretkills_mid_1", "inhibkills_mid_1", "totminionskilled_mid_1", "neutralminionskilled_mid_1", "ownjunglekills_mid_1", "enemyjunglekills_mid_1", "totcctimedealt_mid_1", "champlvl_mid_1", "pinksbought_mid_1", "wardsplaced_mid_1", "wardskilled_mid_1", "firstblood_mid_1")]
dataset_stats.data_mid[,"win"] = dataset_stats.label

dataset_stats.data_jungle = dataset_stats.data[,c("trinket_jungle_1", "kills_jungle_1", "deaths_jungle_1", "assists_jungle_1", "largestkillingspree_jungle_1", "largestmultikill_jungle_1", "killingsprees_jungle_1", "longesttimespentliving_jungle_1", "doublekills_jungle_1", "triplekills_jungle_1", "quadrakills_jungle_1", "pentakills_jungle_1", "totdmgdealt_jungle_1", "magicdmgdealt_jungle_1", "physicaldmgdealt_jungle_1", "truedmgdealt_jungle_1", "largestcrit_jungle_1", "totdmgtochamp_jungle_1", "magicdmgtochamp_jungle_1", "physdmgtochamp_jungle_1", "truedmgtochamp_jungle_1", "totheal_jungle_1", "totunitshealed_jungle_1", "dmgselfmit_jungle_1", "dmgtoobj_jungle_1", "dmgtoturrets_jungle_1", "visionscore_jungle_1", "totdmgtaken_jungle_1", "magicdmgtaken_jungle_1", "physdmgtaken_jungle_1", "truedmgtaken_jungle_1", "goldearned_jungle_1", "goldspent_jungle_1", "turretkills_jungle_1", "inhibkills_jungle_1", "totminionskilled_jungle_1", "neutralminionskilled_jungle_1", "ownjunglekills_jungle_1", "enemyjunglekills_jungle_1", "totcctimedealt_jungle_1", "champlvl_jungle_1", "pinksbought_jungle_1", "wardsplaced_jungle_1", "wardskilled_jungle_1", "firstblood_jungle_1")]
dataset_stats.data_jungle[,"win"] = dataset_stats.label

dataset_stats.data_top = dataset_stats.data[,c("trinket_top_1", "kills_top_1", "deaths_top_1", "assists_top_1", "largestkillingspree_top_1", "largestmultikill_top_1", "killingsprees_top_1", "longesttimespentliving_top_1", "doublekills_top_1", "triplekills_top_1", "quadrakills_top_1", "pentakills_top_1", "totdmgdealt_top_1", "magicdmgdealt_top_1", "physicaldmgdealt_top_1", "truedmgdealt_top_1", "largestcrit_top_1", "totdmgtochamp_top_1", "magicdmgtochamp_top_1", "physdmgtochamp_top_1", "truedmgtochamp_top_1", "totheal_top_1", "totunitshealed_top_1", "dmgselfmit_top_1", "dmgtoobj_top_1", "dmgtoturrets_top_1", "visionscore_top_1", "totdmgtaken_top_1", "magicdmgtaken_top_1", "physdmgtaken_top_1", "truedmgtaken_top_1", "goldearned_top_1", "goldspent_top_1", "turretkills_top_1", "inhibkills_top_1", "totminionskilled_top_1", "neutralminionskilled_top_1", "owntopkills_top_1", "enemytopkills_top_1", "totcctimedealt_top_1", "champlvl_top_1", "pinksbought_top_1", "wardsplaced_top_1", "wardskilled_top_1", "firstblood_top_1")]
dataset_stats.data_top[,"win"] = dataset_stats.label

dataset_stats.cor_match = cor(dataset_stats.data_match)
dataset_stats.melt_match = melt(dataset_stats.cor_match)

dataset_stats.cor_carry = cor(dataset_stats.data_carry)
dataset_stats.melt_carry = melt(dataset_stats.cor_carry)

dataset_stats.cor_supp = cor(dataset_stats.data_supp)
dataset_stats.melt_supp = melt(dataset_stats.cor_supp)

dataset_stats.cor_mid = cor(dataset_stats.data_mid)
dataset_stats.melt_mid = melt(dataset_stats.cor_mid)

dataset_stats.cor_jungle = cor(dataset_stats.data_jungle)
dataset_stats.melt_jungle = melt(dataset_stats.cor_jungle)

dataset_stats.cor_top = cor(dataset_stats.data_top)
dataset_stats.melt_top = melt(dataset_stats.cor_top)

ggplot(dataset_stats.melt_match, aes(Var1, Var2, fill = value, label = round(value, 1))) + geom_tile() + geom_text() + theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(dataset_stats.melt_carry, aes(Var1, Var2, fill = value, label = round(value, 1))) + geom_tile() + geom_text(size = 2) + theme(text = element_text(size=5), axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(dataset_stats.melt_supp, aes(Var1, Var2, fill = value, label = round(value, 1))) + geom_tile() + geom_text(size = 2) + theme(text = element_text(size=5), axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(dataset_stats.melt_mid, aes(Var1, Var2, fill = value, label = round(value, 1))) + geom_tile() + geom_text(size = 2) + theme(text = element_text(size=5), axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(dataset_stats.melt_jungle, aes(Var1, Var2, fill = value, label = round(value, 1))) + geom_tile() + geom_text(size = 2) + theme(text = element_text(size=5), axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(dataset_stats.melt_top, aes(Var1, Var2, fill = value, label = round(value, 1))) + geom_tile() + geom_text(size = 2) + theme(text = element_text(size=5), axis.text.x = element_text(angle = 90, hjust = 1))
